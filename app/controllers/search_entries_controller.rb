class SearchEntriesController < ApplicationController
  before_action :authenticate_user!
  def index
    @search_entries = SearchEntry.where("name LIKE ? OR body LIKE ? OR image LIKE ?", "%#{params[:query]}%", "%#{params[:query]}%", "%#{params[:query]}%") if params[:query]
  end
end
