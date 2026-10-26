with Ada.Directories;

with Diskflags;

procedure Diskflags_Tests.Marks is

   --  Setting and clearing flags, also in folders that do not exist yet

   Folder : constant String := "marks_test_dir";
   Path   : constant String := Folder & "/nested/deeper/flag";
begin
   Reset (Folder);

   declare
      Flag : Diskflags.Flag := Diskflags.New_Flag (Diskflags.Some_Path (Path));
   begin
      --  Paths are made absolute on creation
      pragma Assert
        (String (Flag.Path) = Ada.Directories.Full_Name (Path));

      pragma Assert (not Flag.Exists);

      Flag.Mark (Done => True);                      -- Creates the folders
      pragma Assert (Flag.Exists);
      pragma Assert (Ada.Directories.Exists (Path));

      Flag.Mark (Done => True);                      -- Again, still set
      pragma Assert (Flag.Exists);

      Flag.Mark (Done => False);
      pragma Assert (not Flag.Exists);

      Flag.Mark (Done => False);                     -- Again, still clear
      pragma Assert (not Flag.Exists);

      --  The function-friendly versions

      Flag.Mark_Done;
      pragma Assert (Flag.Exists);
      Flag.Mark_Undone;
      pragma Assert (not Flag.Exists);
   end;

   Reset (Folder);
end Diskflags_Tests.Marks;
