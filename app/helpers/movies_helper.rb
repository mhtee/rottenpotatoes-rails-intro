module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end

  def hilite_helper(field)
    if(params[:sort].to_s == field)
      return 'hilite'
    else
       return nil
    end
  end
  
  def helper_select(movie)
    if params[:ratings] == nil
      return true
    else
      return params[:ratings].has_key?(movie.rating)
    end
  end
end
