pragma Warnings (Off);
with Ada.Assertions; use Ada.Assertions;
--  Make Assert visible to children
pragma Warnings (On);

package Diskflags_Tests is

   procedure Reset (Folder : String);
   --  Remove Folder and all its contents, if it exists, so each test starts
   --  from scratch

end Diskflags_Tests;
