-----------------------------------------------------------------------
--                               G P S                               --
--                                                                   --
--                      Copyright (C) 2003-2007, AdaCore             --
--                                                                   --
-- GPS is free  software;  you can redistribute it and/or modify  it --
-- under the terms of the GNU General Public License as published by --
-- the Free Software Foundation; either version 2 of the License, or --
-- (at your option) any later version.                               --
--                                                                   --
-- This program is  distributed in the hope that it will be  useful, --
-- but  WITHOUT ANY WARRANTY;  without even the  implied warranty of --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU --
-- General Public License for more details. You should have received --
-- a copy of the GNU General Public License along with this program; --
-- if not,  write to the  Free Software Foundation, Inc.,  59 Temple --
-- Place - Suite 330, Boston, MA 02111-1307, USA.                    --
-----------------------------------------------------------------------

with GNAT.Scripts;        use GNAT.Scripts;
with GNAT.Scripts.Python; use GNAT.Scripts.Python;
with GNAT.Scripts.Shell;  use GNAT.Scripts.Shell;

package body Common is

   procedure On_Hello (Data : in out Callback_Data'Class; Command : String);

   procedure On_Hello (Data : in out Callback_Data'Class; Command : String) is
      pragma Unreferenced (Command);
   begin
      Set_Return_Value (Data, "Hello " & Nth_Arg (Data, 1, "world") & " !");
   end On_Hello;

   ------------------------------------
   -- Register_Scripts_And_Functions --
   ------------------------------------

   function Register_Scripts_And_Functions return Scripts_Repository is
      Repo : Scripts_Repository;
   begin
      --  Register all scripting languages. In practice, you only need to
      --  register those you intend to support

      Repo := new Scripts_Repository_Record;
      Register_Shell_Scripting  (Repo);
      Register_Python_Scripting (Repo, "Hello");
      Register_Standard_Classes (Repo, "Console");

      --  Now register our custom functions. Note that we do not need to
      --  register them once for every support language, once is enough, they
      --  are automatically exported to all registered languages.

      --  Available as "Hello.hello("world")" in python,
      --  and "hello world" in shell script
      Register_Command
        (Repo, "hello", 0, 1,
         Handler => On_Hello'Unrestricted_Access);

      return Repo;
   end Register_Scripts_And_Functions;

end Common;
