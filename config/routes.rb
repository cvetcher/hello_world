Rails.application.routes.draw do
	put 'hello/:name', to: 'hello#save'
	get 'hello/:name', to: 'hello#greet'
end
