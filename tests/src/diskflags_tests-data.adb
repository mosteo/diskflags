with Diskflags;

procedure Diskflags_Tests.Data is

   --  Flags set with data keep it byte for byte, and flags set without data
   --  have none

   Folder : constant String := "data_test_dir";

   CR : constant Character := Character'Val (13);
   LF : constant Character := Character'Val (10);

   function New_Flag (Name : String) return Diskflags.Flag
   is (Diskflags.New_Flag (Diskflags.Some_Path (Folder & "/" & Name)));

   procedure Check (Data : String) is
      Flag : constant Diskflags.Flag := New_Flag ("flag.toml");
   begin
      Flag.Mark_Done (Data);
      pragma Assert (Flag.Exists);
      pragma Assert (Flag.Data = Data, "Data not kept: " & Flag.Data);
   end Check;

begin
   Reset (Folder);

   --  A flag without data has none

   declare
      Flag : constant Diskflags.Flag := New_Flag ("plain");
   begin
      Flag.Mark_Done;
      pragma Assert (Flag.Data = "");
   end;

   --  Data is kept as is: text, line endings of any kind, non-ASCII (UTF-8)
   --  bytes, a NUL, or nothing at all. It also replaces the previous data.

   Check ("url = ""https://example.com/repo.git""" & LF
          & "commit = ""0123456789abcdef""" & LF);
   Check ("line 1" & CR & LF & "line 2" & CR & LF);
   Check ("C" & Character'Val (16#C3#) & Character'Val (16#A9#) & "sar");
   Check ("before" & Character'Val (0) & "after");
   Check ("");
   Check ("a much longer text than any of the ones before, "
          & "to check that shorter data replaces it completely");
   Check ("short");

   --  Data can be stored in a folder that does not exist yet

   declare
      Flag : constant Diskflags.Flag := New_Flag ("new/folder/flag.toml");
   begin
      Flag.Mark_Done ("data");
      pragma Assert (Flag.Data = "data");
   end;

   --  Clearing a flag with data removes it

   declare
      Flag : constant Diskflags.Flag := New_Flag ("flag.toml");
   begin
      Flag.Mark_Undone;
      pragma Assert (not Flag.Exists);
   end;

   Reset (Folder);
end Diskflags_Tests.Data;
