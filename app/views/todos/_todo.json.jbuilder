json.extract! todo, :id, :title, :content, :due, :done, :created_at, :updated_at
json.url todo_url(todo, format: :json)
