function clean_stdlibs(dir = pwd(); dryrun=false)
	allfiles = readdir(dir)
	stdlib_version_files = [splitext(f)[1] => read_hash(joinpath(dir,f)) for f in allfiles if splitext(f)[2] == ".version"]
	dirs = [f for f in allfiles if isdir(joinpath(dir, f))]
	for fp in stdlib_version_files
		stdlib_tag = first(fp) * "-"
		dir_current_version = stdlib_tag * last(fp)
		for d in dirs
			startswith(d, stdlib_tag) || continue
			path = joinpath(dir, d)
			# don't delete the one that matches the version being used
			if d == dir_current_version
				@info "Skipping matching version $dir_current_version"
				continue
			end
			if dryrun
				@warn "Going to delete $path"
			else
				@warn "Deleting $path"
				rm(path, force=true, recursive=true)
			end
		end
	end
end

function read_hash(filename)
	for line in eachline(filename)
		if contains(line, "SHA1")
			return strip(split(line, '=')[2])
		end
	end
end
