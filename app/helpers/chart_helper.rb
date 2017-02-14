module ChartHelper
  @logger = MyLogger.factory(self)

  def bid_distribution(data)
    column_chart data, library: {
        # title: 'This is a chart',
        vAxis: {
          format: '',
          gridlines: {count: 4}
        }
    }
  end
end
