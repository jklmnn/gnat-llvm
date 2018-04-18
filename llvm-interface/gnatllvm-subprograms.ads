------------------------------------------------------------------------------
--                             G N A T - L L V M                            --
--                                                                          --
--                     Copyright (C) 2013-2018, AdaCore                     --
--                                                                          --
-- This is free software;  you can redistribute it  and/or modify it  under --
-- terms of the  GNU General Public License as published  by the Free Soft- --
-- ware  Foundation;  either version 3,  or (at your option) any later ver- --
-- sion.  This software is distributed in the hope  that it will be useful, --
-- but WITHOUT ANY WARRANTY;  without even the implied warranty of MERCHAN- --
-- TABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public --
-- License for  more details.  You should have  received  a copy of the GNU --
-- General  Public  License  distributed  with  this  software;   see  file --
-- COPYING3.  If not, go to http://www.gnu.org/licenses for a complete copy --
-- of the license.                                                          --
------------------------------------------------------------------------------

with Atree; use Atree;
with Einfo; use Einfo;
with Sinfo; use Sinfo;
with Table; use Table;
with Types; use Types;
with Uintp; use Uintp;

with GNATLLVM.Environment; use GNATLLVM.Environment;

package GNATLLVM.Subprograms is

   package Nested_Functions_Table is new Table.Table
     (Table_Component_Type => Node_Id,
      Table_Index_Type     => Nat,
      Table_Low_Bound      => 1,
      Table_Initial        => 10,
      Table_Increment      => 5,
      Table_Name           => "Nested_Function_Table");
   --  Table of nested functions to elaborate

   --  When we want to create an overloaded intrinsic, we need to specify
   --  what operand signature the intrinsic has.  The following are those
   --  that we currently support.

   type Overloaded_Intrinsic_Kind is
     (Unary, Binary, Overflow, Memcpy, Memset);

   function Build_Intrinsic
     (Kind : Overloaded_Intrinsic_Kind;
      Name : String;
      TE   : Entity_Id) return GL_Value
     with Pre => Is_Type (TE) and then RM_Size (TE) /= No_Uint,
          Post => Present (Build_Intrinsic'Result);
   --  Build an intrinsic function of the specified type, name, and kind

   function Get_Default_Alloc_Fn return GL_Value
     with Post => Present (Get_Default_Alloc_Fn'Result);
   --  Get default function to use for allocting memory

   function Get_Memory_Compare_Fn return GL_Value
     with Post => Present (Get_Memory_Compare_Fn'Result);
   --  Get function to use to compare memory

   function Get_Stack_Save_Fn return GL_Value
     with Post => Present (Get_Stack_Save_Fn'Result);
   --  Get function to save stack pointer

   function Get_Stack_Restore_Fn return GL_Value
     with Post => Present (Get_Stack_Restore_Fn'Result);
   --  Get function to restore stack pointer

   function Get_LCH_Fn return GL_Value
     with Post => Present (Get_LCH_Fn'Result);
   --  Get function for our last-chance handler

   function Get_Static_Link (Node : Entity_Id) return GL_Value
     with Pre  => Present (Node),
          Post => Present (Get_Static_Link'Result);
   --  Build and return the static link to pass to a call to Node

   function Emit_Call (Call_Node : Node_Id) return GL_Value
     with Pre  => Nkind (Call_Node) in N_Subprogram_Call,
          Post => Present (Emit_Call'Result);
   --  Helper for Emit/Emit_Expression: compile a call statement/expression and
   --  return its result value.

   procedure Emit_LCH_Call (Node : Node_Id)
     with Pre  => Present (Node);
   --  Generate a call to __gnat_last_chance_handler

   procedure Emit_One_Body (Node : Node_Id)
     with Pre => Present (Node);
   --  Generate code for one given subprogram body

   function Emit_Subprogram_Decl (Subp_Spec : Node_Id) return GL_Value
     with Post => Present (Emit_Subprogram_Decl'Result);
   --  Compile a subprogram declaration, save the corresponding LLVM value to
   --  the environment and return it.

   procedure Emit_Subprogram_Body (Node : Node_Id)
     with Pre => Present (Node);
   --  Compile a subprogram body and save it in the environment

   function Node_Enclosing_Subprogram (Node : Node_Id) return Node_Id
     with Pre  => Present (Node),
          Post => Present (Node_Enclosing_Subprogram'Result);
   --  Return the enclosing subprogram containing Node

   function Subp_Ptr (Node : Node_Id) return GL_Value
     with Pre  => Present (Node), Post => Present (Subp_Ptr'Result);
   --  Return the subprogram pointer associated with Node

end GNATLLVM.Subprograms;
