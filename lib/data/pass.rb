class Pass
  CUSTOM_METHODS = {
      get_tile_type: 2,
      get_tile_rotation: 2,
      get_tile_color: 2,

      get_block_type: 3,
      get_block_rotation: 3,
      get_block_color: 3,
      get_block_decorations: 3
  }

  CUSTOM_DEFAULTS = {
      get_tile_type: :none,
      get_tile_rotation: :deg0,
      get_tile_color: 0x000000,

      get_block_type: :none,
      get_block_rotation: :deg0,
      get_block_color: 0x000000,
      get_block_decorations: [:none, :none, :none, :none]
  }

  # contains the blocks for generation
  attr_reader :customs
  attr_reader :world

  def initialize(world, **options)
    @world = world
    @customs = {}

    fail "Bad custom name in Pass" if options.keys.any? {|k| CUSTOM_METHODS[k]}
    fail "Custom had wrong number of args" if options.any? {|k, v| CUSTOM_METHODS[k] == v.parameters.count}
    @customs = options.dup
  end

  def get_tile(x, y)
    tile = Tile.new
    tile.type = run(:get_tile_type, x, y)
    return nil unless tile.type
    tile.rotation = run(:get_tile_rotation, x, y) || :none
    tile.color = run(:get_tile_color, x, y)|| 0xFF_FFFFFF
    tile
  end

  def get_block(x, y, z)
    block = Block.new
    block.type = run(:get_block_type, x, y, z)
    return nil unless block.type
    block.rotation = run(:get_block_rotation, x, y, z) || :none
    block.color = run(:get_block_color, x, y, z) || 0xFF_FFFFFF
    block.decorations = run(:get_block_decorations, x, y, z) || {}
    block
  end

  def define(name, &block)
    fail "Bad custom name" unless CUSTOM_METHODS.keys.include? name
    fail "Wrong number of arguments for custom" unless CUSTOM_METHODS[name] == block.parameters.count
    @customs[name] = block
  end

  # Used to capture arguments to be passed to a block
  def run(name, *args)
    custom = self[name]
    return unless custom
    proc = Proc.new do
      custom.call *args
    end

    world.instance_exec &proc
  end

  def [] custom
    @customs[custom]
  end
end