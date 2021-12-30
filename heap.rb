require_relative 'common'


class EmptyHeapError < Exception
end


class HeapStorageCapacityTooSmallError < Exception
end


class HeapifyDirection
    DOWN = 0
    UP = 1
end


class HeapNode
    def initialize(heap, index)
        @is_root = index == Heap::ROOT_INDEX
        @heap = heap
        @index = index
    end

    def value
        @heap.storage[@index]
    end

    def value=(new_val)
        @heap.storage[@index] = new_val
    end

    def heapify_down
        left, right = self.left, self.right
        return if left.nil? and right.nil?

        node = right
        if not left.nil? and not right.nil?
            # Favor the smallest or largest child node as a swap partner
            # depending on if one is working with a min or max heap.
            # The comparer will return true if the first value meets this
            # criteria.
            node = left if @heap.comparer(left.value, right.value)
        elsif not left.nil?
            node = left
        end
        self.try_swap_value_with(node, HeapifyDirection::DOWN)
    end

    def heapify_up
        parent = self.parent()
        self.try_swap_value_with(parent, HeapifyDirection::UP) unless parent.nil?
    end

    def left
        self.from_index(2 * @index)
    end

    def right
        self.from_index(2 * @index + 1)
    end

    def parent
        HeapNode.new(@heap, @index / 2) unless @is_root
    end

    private

    def from_index(index)
        HeapNode.new(@heap, index) unless @heap.is_out_of_range? index
    end

    def try_swap_value_with(other, direction)
        return if other.nil?

        val, other_val = self.value, other.value
        if direction == HeapifyDirection::DOWN and @heap.comparer(other_val, val)
            self.value = other_val
            other.value = val
            other.heapify_down
        elsif direction == HeapifyDirection::UP and @heap.comparer(val, other_val)
            self.value = other_val
            other.value = val
            other.heapify_up
        end
    end
end


class Heap
    # The first element is always meant to be empty to make the
    # calculations of the parent and child nodes easier.
    ROOT_INDEX = 1
    attr_reader :storage

    def initialize(is_min: true, capacity: 30)
        raise HeapStorageCapacityTooSmallError if capacity < 5
        @storage = Array.new(capacity+1)
        @comparer = is_min ? lambda {|x, y| x < y} : lambda {|x, y| x > y}
        @size = 0
    end

    def comparer(x, y)
        @comparer.call(x, y)
    end

    def is_out_of_range?(index)
        index > @size
    end

    def peek
        @storage[ROOT_INDEX] if @size > 0
    end

    def store(num)
        @size += 1
        @storage[@size] = num
        setting_root = @size == ROOT_INDEX
        HeapNode.new(self, @size).heapify_up unless setting_root
    end

    def take
        raise EmptyHeapError if @size == 0
        # Choosing the last value to temporarily put in the root is
        # arbitrary but requires no extra processing time other than
        # what it takes to let it settle into its new position
        taken = @storage[ROOT_INDEX]
        @size -= 1
        @storage[ROOT_INDEX] = @storage[@size]
        HeapNode.new(self, ROOT_INDEX).heapify_down if @size > 1
        taken
    end
end


class HeapSorter < BaseSorter
    def initialize(small_sorter)
        @small_sorter = small_sorter
        super('Heap')
    end

    def sort(ary, count = nil)
        count = ary.size if count.nil?
        return @small_sorter.sort(ary, count) if count < 10

        heap = Heap.new(capacity: count)
        ary.each do |a|
            heap.store(a)
        end
        0.upto(count-1).each do |i|
            ary[i] = heap.take()
        end
    end
end
