class InfiniteCube < FiniteIsometricWorld
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
      mod_x = x % 5
      mod_y = y % 5

      if z < 3 and (1..3).include?(mod_x) and (1..3).include?(mod_y)
        :block
      else
        nil
      end
    end

    @passes[0].define :get_block_color do |x, y, z|
      0xFF_FF0000
    end

    @passes[0].define(:get_block_rotation) {|x, y, z| :deg0}
  end
end