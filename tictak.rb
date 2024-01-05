class Game
  @@position = Array.new(3) {Array.new(3, ' ')}
  MOVE_ERROR = 'Move already made'

  def print_board
    @@position.each do |row|
      puts row.join(' | ')
      puts '----------'
    end
  end

  def make_move(x_pos, y_pos, player)
    if @@position[x_pos][y_pos] == ' '
      @@position[x_pos][y_pos] = player
    else
      MOVE_ERROR
    end
  end

  def check_winner(player)
    winning_positions = [
      [[0, 0], [0, 1], [0, 2]],
      [[1, 0], [1, 1], [1, 2]],
      [[2, 0], [2, 1], [2, 2]],
      [[0, 0], [1, 1], [2, 2]],
      [[0, 2], [1, 1], [2, 0]],
      [[0, 0], [1, 0], [2, 0]],
      [[0, 1], [1, 1], [2, 1]],
      [[0, 2], [1, 2], [2, 2]]
    ]

    winning_positions.each do |position|
      return true if position.all? do |move|
        @@position[move[0]][move[1]] == player
      end
    end
    false
  end

  def play_game
    p1 = 'x'
    p2 = 'o'
    turn_number = 0

    loop do
      print_board
      current_player = turn_number.even? ? p1 : p2
      puts "Player #{current_player} turn:"
      x_pos = gets.to_i
      y_pos = gets.to_i

      if make_move(x_pos, y_pos, current_player) != MOVE_ERROR
        if check_winner(current_player)
          puts 'WINNER'
          print_board
          return "Player #{current_player} wins"
        else
          turn_number += 1
        end
      else
        puts MOVE_ERROR
      end
    end
  end
end

play = Game.new
p play.play_game
