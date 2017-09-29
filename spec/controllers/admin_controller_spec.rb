require 'spec_helper'

describe AdminController do
  fixtures :customers,:products

  before(:each) do
    user=customers(:one)
    login_admin(user)
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

end
