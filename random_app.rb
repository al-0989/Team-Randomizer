require "sinatra"
require "sinatra/reloader"


enable :sessions

get "/" do
  @names = session[:names]
  @num_of_team = session[:num_of_team]
  erb :pick_rand, layout: :random_layout
end

get "/pick_random" do
  redirect to "/"
end

post "/pick_random" do

  @names = params[:names]
  session[:names] = @names
  session[:arr_of_teams] = []

  students_arr = params[:names].split(",")

  @num_of_team = params[:team_count].to_i
  session[:num_of_team]=@num_of_team

  shuffled_names_arr = shuffleNames(students_arr)

  method = params[:method]

  if @num_of_team > students_arr.length
    session[:arr_of_teams]<< "Invalid! Number of teams is greater than the number of students entered."
  end

  if method == "count"
    @num_of_team.times do
      session[:arr_of_teams] << [shuffled_names_arr.pop]
    end

    while !shuffled_names_arr.empty?
      session[:arr_of_teams].each do |x|
        next if shuffled_names_arr.empty?
        p x << shuffled_names_arr.pop
      end
      break if shuffled_names_arr.empty?
    end
  else
    session[:arr_of_teams] = shuffled_names_arr.each_slice(@num_of_team).to_a
  end

  redirect to "/"
  # erb :pick_rand, layout: :random_layout
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
  if  arr.compact! == nil
    []
  else
    arr
  end
end
