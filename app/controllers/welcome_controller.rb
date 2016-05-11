class WelcomeController < ApplicationController
  def index
    @examples = Example.all
  end
end
