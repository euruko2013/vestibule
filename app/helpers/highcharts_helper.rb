module HighchartsHelper
  def time_series_array(objects, group_by_method, first_date, last_date = Date.today)
    first_date.to_date.upto(last_date.to_date).map do |date|
      [date, objects.select{ |o| o.send(group_by_method).to_date == date }.size]
    end
  end
end