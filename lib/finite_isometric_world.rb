require_relative './data/pass'
require_relative './data/draw'



class FiniteIsometricWorld < IsometricWorld
  IsometricWorld.worlds[:FiniteIsometricWorld] = nil

  #ranges of the blocks to display.
  attr_reader :x_range, :y_range, :z_range

  #holds generation passes
  attr_reader :passes

  #holds the blocks from the last completed pass/draw
  attr_reader :tiles, :blocks

  #holds temporary blocks to be transfered after a pass has finished
  attr_reader :tile_canvas, :block_canvas

  def initialize(x_range, y_range, z_range, **options)
    super **options
    @x_range = x_range
    @y_range = y_range
    @z_range = z_range
    #@block_pen = IsometricBlockPen.new self
    #@tile_pen = IsometricTilePen.new self


    clear_tiles
    clear_tile_canvas
    clear_blocks
    clear_block_canvas
    make_passes
  end

  def clear_passes
    @passes = []
  end

  def clear_tiles
    @tiles = Array.make_2d_array(size_x, size_y, :none)
  end

  def clear_tile_canvas
    @tile_canvas = Array.make_2d_array(size_x, size_y)
  end


  def clear_blocks
    @blocks = Array.make_3d_array(size_x, size_y, size_z, :none)
  end

  def clear_block_canvas
    @block_canvas = Array.make_3d_array(size_x, size_y, size_z)
  end

  # method to be overridden to define passes.
  def make_passes
    clear_passes
  end

  # merge the tile and block canvas, used after an operation (like passes or draws)
  def merge_canvases
    x_range.count.times do |x|
      y_range.count.times do |y|
        @tiles[x][y] = tile_canvas[x][y] if tile_canvas[x][y]
      end
    end

    x_range.count.times do |x|
      y_range.count.times do |y|
        z_range.count.times do |z|
          @blocks[x][y][z] = block_canvas[x][y][z] if block_canvas[x][y][z]
        end
      end
    end
  end

  # displays the
  def each_block
    x_range.each do |x|
      y_range.each do |y|
        z_range.each do |z|
          yield x, y, z
        end
      end
    end
  end

  def each_tile
    x_range.each do |x|
      y_range.each do |y|
        yield x, y
      end
    end
  end

  def run_tile_pass(pass)
    each_tile do |x, y|
      tile_canvas[x - x_range.first][y - y_range.first] = pass.get_tile(x, y)
    end
  end

  def run_block_pass(pass)
    each_block do |x, y, z|
      block_canvas[x - x_range.first][y - y_range.first][z - z_range.first] = pass.get_block(x, y, z)
    end
  end

  def make_world
    passes.each do |op|
      run_tile_pass op
      run_block_pass op
      merge_canvases
    end
  end

  def draw_tile(x_pos, y_pos, x, y)
    tile = tiles[x][y]
    assets.draw_tile(tile, view, get_tile_position(x_pos, y_pos))
  end

  def draw_tiles
    case view
      when :south_east
        y_range.each do |y|
          x_range.each do |x|
            draw_tile(x, y, x, y)
          end
        end
      when :south_west
        x_range.each do |y|
          y_range.each do |x|
            draw_tile(x, y, size_x - 1 - y, x)
          end
        end
      when :north_west
        y_range.each do |y|
          x_range.each do |x|
            draw_tile(x, y, size_x - 1 - x, size_y - 1- y)
          end
        end
      when :north_east
        x_range.each do |y|
          y_range.each do |x|
            draw_tile(x, y, y, size_y - 1 - x)
          end
        end
      else
        throw Exception.new("view was out of bounds!")
    end
  end

  def draw_block(x_pos, y_pos, z_pos, x, y, z)
    block = blocks[x][y][z]
    assets.draw_block(block, view, get_block_position(x_pos, y_pos, z_pos))
  end

  def draw_blocks
    case view
      when :south_east
        y_range.each do |y|
          x_range.each do |x|
            z_range.each do |z|
              draw_block(x - x_range.first, y - y_range.first, z - z_range.first, x, y, z)
            end
          end
        end
      when :south_west
        x_range.each do |y|
          y_range.each do |x|
            z_range.each do |z|
              draw_block(x - x_range.first, y - y_range.first, z - z_range.first, size_x - 1 - y, x, z)
            end
          end
        end
      when :north_west
        y_range.each do |y|
          x_range.each do |x|
            z_range.each do |z|
              draw_block(x - x_range.first, y - y_range.first, z - z_range.first, size_x - 1 - x, size_y - 1 - y, z)
            end
          end
        end
      when :north_east
        x_range.each do |y|
          y_range.each do |x|
            z_range.each do |z|
              draw_block(x - x_range.first, y - y_range.first, z - z_range.first, y, size_y - 1 - x, z)
            end
          end
        end
      else
        throw Exception.new("view was out of bounds!")
    end
  end
end