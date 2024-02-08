package Diskflags is

   type Flag (<>) is tagged private;

   type Some_Path is new String;

   function New_Flag (Path : Some_Path) return Flag;
   --  This is the destination file whose operation we want to ensure was
   --  completed, including the file flag: a download/copy destination, for
   --  example. E.g.: /path/to/myflag. During creation, it will converted to
   --  absolute if it isn't already.

   function Exists (This : Flag) return Boolean;
   --  Say if the flag exists (so whatever it signals has happened)

   procedure Mark (This : in out Flag;
                   Done : Boolean)
     with Post => This.Exists = Done;
   --  Set/remove the canary flag of the operation on path being complete. This
   --  should be called when the operation has actually been completed.

   procedure Mark_Done (This : Flag)
     with Post => This.Exists;
   --  Alternative that can be used within a expression

   procedure Mark_Undone (This : Flag)
     with Post => not This.Exists;

   function Path (This : Flag) return Some_Path;

private

   type Flag (Length : Natural) is tagged record
      Path : Some_Path (1 .. Length);
   end record;

   ----------
   -- Path --
   ----------

   function Path (This : Flag) return Some_Path is (This.Path);

end Diskflags;
