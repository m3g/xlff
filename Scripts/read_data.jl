
function read_data(filename; cols=[1,2])

  # counting the number of data points
  
  file = open(filename)
  ndata = 0
  for line in eachline(file) 
    if ! isempty(strip(line))
      line = lstrip(line)
      if line[1:1] != "#" # ignoring comment lines
        ndata = ndata + 1
      end
    end
  end
  seek(file,0)
  
  # set vectors that will contain the actual data
  
  x = [ 0. for i in 1:ndata ]
  y = [ 0. for i in 1:ndata ]
  
  i = 0
  for line in eachline(file) 
    if ! isempty(strip(line))
      line = lstrip(line)
      if line[1:1] != "#" # ignoring comment lines
        i = i + 1
        line_data = split(line)
        x[i] = parse(Float64,line_data[cols[1]])
        y[i] = parse(Float64,line_data[cols[2]])
      end
    end
  end
  close(file)

  return ndata, x, y

end

