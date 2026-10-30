# frozen_string_literal: true

SimpleCov.configure do
  cover "lib/**/*.rb"
  merging false
  coverage(:line) do
    minimum 100
    minimum 100, per: :file
  end
  coverage(:branch) do
    minimum 100
    minimum 100, per: :file
  end
end
