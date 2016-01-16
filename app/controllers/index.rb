get '/' do
  @reviews = Review.all
  erb :index
end

get '/page2' do
 @reviews = Review.all
  erb :'pages/_about', layout: false
end

# get '/page3' do
#   @reviews = Review.all
#   erb :about
# end

get '/location' do
  @restaurants = Review.all
  content_type(:json)
  @restaurants.to_json
end
