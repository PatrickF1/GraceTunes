class API::PaginatedResult
  def initialize(data, filtered_count, total_count)
    @data = data
    @filtered_count = filtered_count
    @total_count = total_count
  end
end