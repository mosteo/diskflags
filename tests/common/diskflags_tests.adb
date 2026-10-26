with Ada.Directories;

package body Diskflags_Tests is

   -----------
   -- Reset --
   -----------

   procedure Reset (Folder : String) is
   begin
      if Ada.Directories.Exists (Folder) then
         Ada.Directories.Delete_Tree (Folder);
      end if;
   end Reset;

end Diskflags_Tests;
