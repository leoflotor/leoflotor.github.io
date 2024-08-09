function hfun_bar(vname)
  val = Meta.parse(vname[1])
  return round(sqrt(val), digits=2)
end

function hfun_m1fill(vname)
  var = vname[1]
  return pagevar("index", var)
end

function lx_baz(com, _)
  # keep this first line
  brace_content = Franklin.content(com.braces[1]) # input string
  # do whatever you want here
  return uppercase(brace_content)
end

@delay function hfun_blogposts()
    pages = readdir("pages/")    # read the directory where all entries are located
    filter!(endswith(".md"), pages)    # only select markdown files
    sort!(pages, by=x->pagevar("pages/$x","date"), rev=true)    # put the most recent entries at the top of the list

    io = IOBuffer()
    write(io, """<div class="franklin-content">""")
    for page in pages
        ps = splitext(page)[1]
        write(io, "<li>")
        local_path = "pages/$ps"
        url = "/pages/$ps"
        title = pagevar(local_path, "title")
        pubdate = pagevar(local_path, "date")
        write(io, """[$pubdate] ... """)
        write(io, """<a href="$url"> $title </a></b><p>""")
    end
    write(io, "</div>")
    return String(take!(io))
end

