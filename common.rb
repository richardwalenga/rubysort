unless Array.instance_methods.include? :swap_values!
    class Array
        def swap_values!(x, y)
            if x != y
                self[x], self[y] = self[y], self[x]
            end
        end
    end
end


class BaseSorter
    attr_reader :name
    def initialize(name)
        @name = name
    end

    def sort(ary, count: nil)
        raise "SubclassResponsibility"
    end
end