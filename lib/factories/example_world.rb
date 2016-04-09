class ExampleWorld < FiniteIsometricWorld
  def initialize(size_x, size_y, size_z)
    super 0, size_x, 0, size_y, 0 , size_z, :simple
  end

  def make_passes
    @passes = []

    @passes[0] = Pass.new(self)
    @passes[0].define :get_block_type do |x, y, z|
      edge = 0
      edge += 1 if x == 0 or x == size_x-1
      edge += 1 if y == 0 or y == size_y-1
      edge += 1 if z == 0 or z == size_z-1
      if edge >= 2
        :block
      else
        :none
      end
    end
    @passes[0].define :get_block_color do
      edge = 0
      edge += 1 if x == 0 or x == size_x-1
      edge += 1 if y == 0 or y == size_y-1
      edge += 1 if z == 0 or z == size_z-1
      case edge
        when 2
          0xFF_FF0000
        when 3
          0xFF_0000FF
      end
    end
  end
end