macro system(k::Symbol, f::Expr) # k should be a Kosmo (TODO: EXPLICITY ERROR OTHERWISE)
    _, args = inspect_func(f)
    argtypes = find_argtypes(args)
    quote
        $f
        push!(($k)._dispatch_types, $argtypes)
    end
end