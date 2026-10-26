# diskflags

[![Alire](https://img.shields.io/endpoint?url=https://alire.ada.dev/badges/diskflags.json)](https://alire.ada.dev/crates/diskflags.html)
[![Tests](https://github.com/mosteo/diskflags/actions/workflows/test.yml/badge.svg)](https://github.com/mosteo/diskflags/actions/workflows/test.yml)

Small files on disk that flag that something has happened, so that it can be
checked later, even by another process or run: a download or copy completed,
a post-processing step done, and so on.

A flag is a file at a given path: it exists once set, and is removed when
cleared. It may also carry some data, stored byte for byte.

## Usage

```ada
with Diskflags;

procedure Example is
   Done : Diskflags.Flag :=
            Diskflags.New_Flag ("/path/to/download/.complete");
begin
   if not Done.Exists then
      --  ... download ...
      Done.Mark (True);   -- Creates any missing folders
   end if;

   --  A flag with data, e.g., to record what was downloaded
   Done.Mark_Done ("url = ""https://example.com/file.tgz""");
   pragma Assert (Done.Data = "url = ""https://example.com/file.tgz""");

   Done.Mark_Undone;      -- Clears it, data included
end Example;
```

- `New_Flag` turns the path absolute.
- `Mark (Done)`, `Mark_Done` and `Mark_Undone` set or clear a flag.
- `Mark_Done (Data)` sets it with `Data`, replacing any previous contents, and
  `Data` reads them back (`""` for a flag set without data).

## License

MIT, see `LICENSE`.
