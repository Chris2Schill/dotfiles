Signature for a config loader function


--
-- 'selection' is the text that was selected in the configurations menu.
-- 'cfg' is the configuration table corresponding to that selection.
-- example:
-- selection = "linux-gcc-x64-debug"
-- cfg = {
--    binaryDir = /home/cschilling/project/build/linux-gcc-x64-debug,
--    on_load = <this-function>
-- }
--
function on_load(selection, cfg)

end
