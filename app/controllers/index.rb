get '/' do
  @reviews = Review.all
  erb :index
end

post '/reviews' do
  @review = Review.create(user_id: session[:user_id], review_title: params[:review_title], image: params[:image], restaurant_name: params[:restaurant_name], latitude: params[:latitude], longitude: params[:longitude], rating: params[:rating], price: params[:price], review_content: params[:review_content], signature: params[:signature], tag1: params[:tag1], tag2: params[:tag2], tag3: params[:tag3])
  if @review.save
    redirect "/"
  else
    erb :effoff
  end
end

get '/reviews' do
  redirect '/'
end

get '/page2' do
 @reviews = Review.all
  erb :'pages/_about', layout: false
end

get '/page3' do
  @reviews = Review.all
   erb :'pages/_page3', layout: false
 end

# post '/contact' do
# mail = Mail.new do
#   from 'mia.lehrer@gmail.com'
#   to params[:email]
#   subject params[:enquiry]
#   body params[:message])
# end

get '/location' do
  @restaurants = Review.all
  content_type(:json)
  @restaurants.to_json
end

get '/admin' do
  if session[:user_id]
    redirect '/admin/dashboard'
  else
  erb :login
  end
end

get '/admin/dashboard' do
  erb :dashboard
end

get '/logout' do
  session.delete(:user_id)
  redirect '/admin'
end

post '/admin' do
  user = User.find_by_username(params[:username])
  if user
  if user.authenticate(params[:username], params[:password])
    session[:user_id] = user.id
    redirect '/admin/dashboard'
  else
    erb :effoff
  end
else
  erb :effoff
end
end

get '/reviews/new' do
  if session[:user_id]
  erb :review
else
  erb :effoff
  end
end

delete '/reviews/:id' do
  @review = Review.find(params[:id])
   if session[:user_id] == @review.user_id
  @review.destroy
  redirect "/"
else
  p "#{@review.user_id} should be #{session[:user_id]}"
  erb :effoff
end
end

get '/reviews/:id' do
  @review = Review.find(params[:id])
  erb :_show
end
