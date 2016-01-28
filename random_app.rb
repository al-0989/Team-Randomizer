require "sinatra"
require "sinatra/reloader"

get "/" do
  erb :pick_rand, layout: :random_layout
end

post "/pick_random" do
  @arr_of_teams = []
  @students_arr = params[:names].split(",")
  @num_of_team = params[:team_count].to_i
  shuffled_names_arr = shuffleNames(@students_arr)
  method = params[:method]

  if @num_of_team > @students_arr.length
    p @arr_of_teams << "Invalid! Number of teams is greater than the number of students entered."
  end

  if method == "count"
    @num_of_team.times do
       @arr_of_teams << [shuffled_names_arr.pop]
    end

    while !shuffled_names_arr.empty?
        @arr_of_teams.each do |x|
          next if shuffled_names_arr.empty?
          p x << shuffled_names_arr.pop
        end
        break if shuffled_names_arr.empty?
    end
  else
    @arr_of_teams = shuffled_names_arr.each_slice(@num_of_team).to_a
  end

  erb :pick_rand, layout: :random_layout
end

## Method used to shuffle names
def shuffleNames(arr)
  # fisher-yates algorithm
  for i in 1..arr.length
    random_student = rand(0..arr.length-1) # pick a random student
    tempHold = arr[i];
    arr[i] = arr[random_student];
    arr[random_student] = tempHold;
  end
  arr.compact
end
