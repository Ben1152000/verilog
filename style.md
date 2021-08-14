# Verilog Coding Conventions
## Alignment/Spacing
### Tabs
IF modifying SPARC code, use 3 spaces.
If writing your own, use 4 spaces.
Be sure to have expandtab set in vi.
### Text File Width
160 character upper limit.  120 is strongly encouraged.  80 is a good goal.
### White space around operators
Lots of spaces.
Space between your if/for and braces:
if (....)
Space between operators:
a && b
No spaces between braces:
((a && b) && c)
### Nested indentation levels
Begin statements on different line from the if/for/etc.
Align begin with the if/for/etc.
#### Case options
Case options should be indented from the case line:
<code>
case (foo)
    2'b00:
endcase
</code>
begin and end should exist for *all* if and case statements.
The begin and end should be aligned with the case option and the contents indented from there.
Newlines between cases (end and next case option) are optional.
### Alignment
Signals should each be declared on their own lines.
Signal widths follow without spaces from types. Signal names are aligned on the next tab stop beyond the longest type.
Alignment of right-hand-sides on assignments are not enforced.
Long (>120 character) boolean expressions are preferred to be broken up and aligned across multiple lines.
## Naming Conventions
### Modules/variables
Modules lower case, delimited by underscores.
Underscore delimiting on constants:
For 'b, do it every 4 characters from the right.
For 'h, do it every 8 characters from the right.
Otherwise, unspecified.
### Special Case Variables
#### Active Low Signals
Active low signals should be postponed with _n
#### Clocks
Clocks are always called clk.
If there is more than one clock, call it clk_something.
#### Flip-Flops & Latches
Flip-flops are always post-pended with _f and inputs to flip-flops are instead post-pended with _next.
Pipe-stage registers should have the pipe stage in their names.
Latches use _latch for the output, and _next for the input.
#### Signal Source in Name
Global output name as your own module name, other people reuse the signal are not allowed to rename the signal.
#### Resets
rst for reset, negative reset rst_n
#### Signal Widths
You cannot have left hand side and right hand side width mismatch
my_signal = {1'b0, your_signal} if my_signal is one bit longer
The only case which is OK is if you have a short constant like: pc = pc + 4 because Verilog cannot support \WIDTH\d1;
#### Signal Naming
Top level signal leaves your model, do not change name through all hierarchies
No short name (normally), be explicit
### Module Coding
#### File Structure
Put all declarations at top of file.
#### Module Declaration
clk and rst at the beginning
Input first, output then, last inout
Declare input and output with width in the module declaration
Parameters, input and output need to be in .signal_name/parameter_name() syntax when instantiating a module
#### Sequential Logic
No combinational logic (except reset) is inside the sequential block
#### Combinational Logic ####
Prefer to use always @ *
Use @ * instead of @ (*)
In always @ * blocks for any left side, put default value first, before case statement
Anything falls in ERROR state goes to IDLES state
All states need to be defined
default: state needs to drive 'x' on all left-hand-side variables within the case statement
#### Defines
Use "define.vh" file
`DEFINE must be used for architectural parameters
#### Assignments
Prefer use always * instead of assign
#### Comments
Liberal use of comments is strongly encouraged
Inline comments only after the definition
### NoC Wire Naming
Broadly, NoC wire naming should be of the format: <src>_<dst>_<type>_noc<N>_<sig>
Where:
* <src> is the source of the interface
* <dst> is the destination of the interface
* <type> is "vr" for val/rdy interfaces and "cr" for credit-based interfaces
* <N> is the noc number (1/2/3)
* <sig> is val/rdy/dat for val/rdy interfaces and val/yum/dat for credit-based interfaces
#### Internal to a module, wire naming should be:
<src>_<dst>_<type>_noc<N>_<sig>
Where:
* <src> is the local source of the interface
* <dst> is the local destination of the interface
#### For a module interface, wire naming should be:
* For input NoCs:  src_mod_<type>_noc<N>_<sig>
* For output NoCs: mod_dst_<type>_noc<N>_<sig>
Where:
* src and dst are the literal strings "src" and "dst", respectively
* mod is some short abbreviation for the module
#### Special case: module with multiple nocN interfaces
* For input NoCs:  src<X>_mod_<type>_noc<N>_<sig>
* For output NoCs: mod_dst<X>_<type>_noc<N>_<sig>
Where:
* <X> is the number of the nocN interface
#### Special case: module with known nocN endpoints
This is intended for modules like the chipset/IO crossbar. In the general case, a module should be instantiable anywhere and thus uses src_ and dst_ in the wire names. If a module (like the chipset/IO crossbar) has NoC interfaces where the endpoints will always be known, those can be named directly, in place of src_/dst_.
* For input NoCs:  <src>_mod_<type>_noc<N>_<sig>
* For output NoCs: mod_<dst>_<type>_noc<N>_<sig>