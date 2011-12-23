module GroupingHelper
  # A place holder is like 'A01.address', 'B01.name'
  # They will be grouped like followings:
  #   {"A"=>[<address>], "B"=>[<name>,<zip>]}
  def grouping(values)
    puts values.to_yaml
    groups = {}
    values.each do |item|
      key = yield item
      m = key.match(/([A-Z])([0-9]*)\.(.*)/)
      group  = m[1]
      number = m[2]
      label  = m[3]
      if groups[group] == nil
        groups[group] = [item]
      else
        groups[group] << item
      end
    end
    return groups
  end
end
