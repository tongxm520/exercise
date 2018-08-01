#Ruby 2.3 introduces a new method on Array and Hash called dig.

Hash.class_eval do
  def dig(*args)
    if args.count>=1
      temp=self
      args.each_with_index do |key,i|
        temp=temp[key]
        return temp if i==args.count-1 or temp.nil?
      end
    end
    return nil
  end
end

