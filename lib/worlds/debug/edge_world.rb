class EdgeWorld < FiniteIsometricWorld
  def initialize(size_x, size_y, size_z, **options)
    super (0...size_x), (0...size_y), (0...size_z)  , asset_name: :simple, **options
  end

  def make_passes
    super

    @passes[0] = Pass.new(self)
    @passes[0].define(:get_tile_type) {|x, y| :tile}
    @passes[0].define(:get_tile_color) {|x, y| 0xFF_FFFFFF}
    @passes[0].define(:get_tile_rotation) {|x, y| :deg0}


    @passes[0].define :get_block_type do |x, y, z|
      edge = 0
      edge += 1 if x == 0 or x == x_range.last-1
      edge += 1 if y == 0 or y == y_range.last-1
      edge += 1 if z == 0 or z == z_range.last-1
      if edge >= 2
        :block
      else
        nil
      end
    end

    @passes[0].define :get_block_color do |x, y, z|
      edge = 0
      edge += 1 if x == 0 or x == x_range.last-1
      edge += 1 if y == 0 or y == y_range.last-1
      edge += 1 if z == 0 or z == z_range.last-1
      case edge
        when 2
          0xFF_FF0000
        when 3
          0xFF_0000FF
        else
          0xFF_00FF00
      end
    end

    @passes[0].define(:get_block_rotation) {|x, y, z| :deg0}
  end
end