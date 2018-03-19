
#---------------------------------------------------------------
#---------------------------------------------------------------
# Differential Tags
type DTag
    tag::Array
end

DTag(x) = DTag([x])

DTag(x...) = DTag([i for i in x] |> sort)

Base.length(t::DTag) = length(t.tag)
Base.:(==)(x::DTag,y::DTag) = x.tag == y.tag
Base.getindex(t::DTag, i::Int) = (t.tag)[i]

function Base.isless(t1::DTag,t2::DTag)
    if length(t1) == length(t2)
        for i in 1:length(t1)
            if t1[i] >= t2[i]
                return false
            end
        end
        t1 == t2 ? (return false ) : (return true)
    elseif length(t1) < length(t2)
        true
    else
        false
    end
end

function hasDuplicates(arr)
    for i in 1:(length(arr)-1)
        for j in (i+1):length(arr)
            if arr[i] == arr[j]
                return true
            end
        end
    end
    false
end

Base.setdiff(t1::DTag, t2::DTag) = DTag(setdiff(t1.tag, t2.tag) |> sort)
Base.intersect(t1::DTag, t2::DTag) = DTag(intersect(t1.tag, t2.tag) |> sort)

tagRemove(t1::DTag, t2::DTag) = intersect(t1,t2) != DTag() ? setdiff(t1,t2) : DTag(-1)
t1 = DTag([1,2])
t2 = DTag([1])


#---------------------------------------------------------------
#---------------------------------------------------------------
# Differentials
type Differential
    terms::SortedDict
end

function printEpsilons(t::DTag)
    str = ""
    for i in t.tag
        str = str*"ϵ$i"
    end
    str
end

function Base.show(io::IO, diff::Differential)
    str = ""
    for (tag, term) in diff.terms
        if tag == DTag()
            str = str*"$(term)$(printEpsilons(tag))"
        elseif str == ""
            str = str*"($(term))$(printEpsilons(tag))"
        else
            str = str*" + ($(term))$(printEpsilons(tag))"
        end
    end
    print(io, str)
end

function Differential(iterable)
    Differential(try delete!(SortedDict(iterable),DTag(-1)) catch SortedDict(iterable) end)
end

function Differential(keys::Union{Array,Tuple}, values::Union{Array,Tuple})
    Differential(try delete!(SortedDict(zip(keys,values)), DTag(-1)) catch SortedDict(zip(keys,values)) end)
end

Base.length(t::Differential) = length(t.terms)
Base.:(==)(x::Differential,y::Differential) = x.terms == y.terms
Base.getindex(t::Differential, i::DTag) = (t.terms)[i]
getTagList(Dx::Differential) = [key for (key, _) in Dx.terms]


function Base.getindex(Dx::Differential, i::Int)
    key = getTagList(Dx)[i]
    key == DTag() ? Dx.terms[key] : Differential(key => Dx.terms[key])
end

function Base.getindex(Dx::Differential, i::UnitRange)
    keys = getTagList(Dx)[i]
    if length(i) == 1
        out = (Dx.terms)[keys...]
    else
        Differential(k => Dx.terms[k] for k in keys)
    end
end

Base.endof(Dx::Differential) = length(Dx |> getTagList)

lastTag(Dx::Differential) = getTagList(Dx)[end]

function tagUnion(x::Differential, y::Differential)
    vcat(x |> getTagList, y |> getTagList) |> sort |> fastuniq
end

function fastuniq(v)
  v1 = Vector{eltype(v)}()
  if length(v)>0
    laste = v[1]
    push!(v1,laste)
    for e in v
      if e != laste
        laste = e
        push!(v1,laste)
      end
    end
  end
  return v1
end

tagCount = 0
