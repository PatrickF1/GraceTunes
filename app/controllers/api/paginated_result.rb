class API::PaginatedResult
  def initialize(data, matching_count, total_count)
    @data = data
    @matching_count = matching_count
    @total_count = total_count
  end
end