with Ada.Directories;

with GNAT.OS_Lib;

package body Diskflags is

   package Dirs renames Ada.Directories;

   -----------------
   -- Create_Tree --
   -----------------

   procedure Create_Tree (Path : String) is
   begin
      if Dirs.Exists (Path) then
         if Dirs.Kind (Path) in Dirs.Directory then
            return;
         else
            raise Constraint_Error with
              "Path already exists and is not a folder: " & Path;
         end if;
      else
         Create_Tree (Dirs.Containing_Directory (Path));
         Dirs.Create_Directory (Path);
      end if;
   end Create_Tree;

   -----------
   -- Touch --
   -----------

   procedure Touch (File : String) is
      use GNAT.OS_Lib;
      Success : Boolean := False;
   begin
      if Is_Regular_File (File) then
         Set_File_Last_Modify_Time_Stamp (File, Current_Time);
      elsif Dirs.Exists (File) then
         raise Constraint_Error with
           "Can't touch non-regular file: " & File;
      else
         Close (Create_File (File, Binary), Success);
         if not Success then
            raise Constraint_Error with
              "Could not touch new file: " & File;
         end if;
      end if;
   end Touch;

   --------------
   -- New_Flag --
   --------------

   function New_Flag (Path : Some_Path) return Flag
   is
      Full : constant Some_Path := Some_Path (Dirs.Full_Name (String (Path)));
   begin
      return (Length => Full'Length,
              Path   => Full);
   end New_Flag;

   ------------
   -- Exists --
   ------------

   function Exists (This : Flag) return Boolean
   is (Dirs.Exists (String (This.Path))
       and then Dirs.Kind (String (This.Path)) in Dirs.Ordinary_File);

   ----------
   -- Mark --
   ----------

   procedure Mark (This : in out Flag;
                   Done : Boolean)
   is
   begin
      if Done then
         Create_Tree (Dirs.Containing_Directory (String (This.Path)));
         Touch (String (This.Path));
      else
         if This.Exists then
            Dirs.Delete_File (String (This.Path));
         end if;
      end if;
   end Mark;

   ---------------
   -- Mark_Done --
   ---------------

   procedure Mark_Done (This : Flag) is
      RW : Flag := This;
   begin
      RW.Mark (Done => True);
   end Mark_Done;

   -----------------
   -- Mark_Undone --
   -----------------

   procedure Mark_Undone (This : Flag) is
      RW : Flag := This;
   begin
      RW.Mark (Done => False);
   end Mark_Undone;

end Diskflags;
