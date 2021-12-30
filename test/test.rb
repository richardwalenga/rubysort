require_relative '../bubble'
require_relative '../heap'
require_relative '../insertion'
require_relative '../selection'
require_relative '../merge'
require_relative '../quick'

require 'logger'
require 'minitest/autorun'
require 'singleton'
require 'time'


unless Array.instance_methods.include? :sorted
    class Array
        def sorted?
            0.upto(size-2).each do |i|
                return false if self[i + 1] < self[i]
            end
            true
        end
    end
end


class SimpleStopWatch
    def start
        @started = Time.new
    end

    def get_elapsed_milliseconds
        (Time.new - @started) * 1000
    end
end


class LoggerSource
    include Singleton

    def initialize
        @logger = Logger.new STDERR
        @logger.level = Logger::INFO
    end

    def logger
        @logger
    end
end


class RandomArraySource
    include Singleton
    CAPACITY = 20000

    def initialize    
        @random_nums = Array.new CAPACITY
        randomizer = Random.new
        0.upto(CAPACITY-1).each do |i|
            @random_nums[i] = randomizer.rand(100000)
        end
    end

    def get_randoms
        @random_nums.clone
    end
end


class HeapStorageTest < MiniTest::Test
    def setup
        @capacity = 10
        @heap = Heap.new(capacity: @capacity)
    end

    def test_can_expand
        @heap.storage[@capacity + 1] = @capacity
        @heap.storage[@capacity + 5] = 2*@capacity
        assert_equal [@capacity, nil, nil, nil, 2*@capacity], @heap.storage[-5..]
    end
end


class SorterTest < MiniTest::Test
    def setup
        @nums = RandomArraySource.instance.get_randoms
    end

    def test_insertion
        self.execute InsertionSorter.new
    end

    def test_bubble
        self.execute BubbleSorter.new
    end

    def test_cocktail
        self.execute CocktailShakerSorter.new
    end

    def test_heap
        self.execute HeapSorter.new(InsertionSorter.new)
    end

    def test_selection
        self.execute SelectionSorter.new
    end

    def test_merge
        self.execute MergeSorter.new(InsertionSorter.new)
    end

    def test_quick
        self.execute QuickSorter.new
    end

    private

    def execute(sorter)
        watch = SimpleStopWatch.new
        watch.start
        sorter.sort @nums
        diff = watch.get_elapsed_milliseconds
        LoggerSource.instance.logger.info(
            "Sorting with %s finished in %i milliseconds" % [sorter.name, diff])
        assert @nums.sorted?
    end
end
