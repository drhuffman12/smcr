crystal_doc_search_index_callback({"repository_name":"smcr","body":"# smcr\n\nState Machine for Crystal\n\n## Installation\n\n1. Add the dependency to your `shard.yml`:\n\n   ```yaml\n   dependencies:\n     smcr:\n       github: drhuffman12/smcr\n   ```\n\n2. Run `shards install`\n\n## Usage\n\nFor the states, we use Enums, which are importable from JSON.\nYou might think that we should use Symbols, but those are NOT JSON import-able!\nSee: https://forum.crystal-lang.org/t/how-to-do-from-json-with-symbol-variables/3379/2 .\n\n```crystal\nrequire \"smcr\"\n```\n\nTODO: Write usage instructions here\n\n## Development\n\nTo enable debug comment logging, set `CRYSTAL_DEBUG` env variable to anything other than an empty string. For example:\n\n```\n# debug logging enabled\nCRYSTAL_DEBUG=soME_nOn_Blank_VALue crystal spec\n\n# debug logging disabled\nCRYSTAL_DEBUG= crystal spec\n```\n\nThis will show at least:\n```\nSmcr::VERSION # => \"0.1.0\"\n```\n\nUse this to output additional debug info like:\n```\np! Smcr::VERSION if Smcr::DEBUG_ENABLED\n```\n\n\n\n## Contributing\n\n1. Fork it (<https://github.com/drhuffman12/smcr/fork>)\n2. Create your feature branch (`git checkout -b my-new-feature`)\n3. Commit your changes (`git commit -am 'Add some feature'`)\n4. Push to the branch (`git push origin my-new-feature`)\n5. Create a new Pull Request\n\n## Contributors\n\n- [Daniel Huffman](https://github.com/drhuffman12) - creator and maintainer\n","program":{"html_id":"smcr/toplevel","path":"toplevel.html","kind":"module","full_name":"Top Level Namespace","name":"Top Level Namespace","abstract":false,"superclass":null,"ancestors":[],"locations":[],"repository_name":"smcr","program":true,"enum":false,"alias":false,"aliased":null,"aliased_html":null,"const":false,"constants":[],"included_modules":[],"extended_modules":[],"subclasses":[],"including_types":[],"namespace":null,"doc":null,"summary":null,"class_methods":[],"constructors":[],"instance_methods":[],"macros":[],"types":[{"html_id":"smcr/Smcr","path":"Smcr.html","kind":"module","full_name":"Smcr","name":"Smcr","abstract":false,"superclass":null,"ancestors":[],"locations":[{"filename":"src/smcr.cr","line_number":5,"url":null},{"filename":"src/smcr/state_machine.cr","line_number":1,"url":null}],"repository_name":"smcr","program":false,"enum":false,"alias":false,"aliased":null,"aliased_html":null,"const":false,"constants":[{"id":"DEBUG_ENABLED","name":"DEBUG_ENABLED","value":"(ENV.keys.includes?(\"CRYSTAL_DEBUG\")) && (!ENV[\"CRYSTAL_DEBUG\"].empty?)","doc":null,"summary":null},{"id":"VERSION","name":"VERSION","value":"{{ (`shards version \\\"/home/drhuffman/_tmp_/github/drhuffman12/smcr/src\\\"`).chomp.stringify }}","doc":null,"summary":null}],"included_modules":[],"extended_modules":[],"subclasses":[],"including_types":[],"namespace":null,"doc":null,"summary":null,"class_methods":[],"constructors":[],"instance_methods":[],"macros":[],"types":[{"html_id":"smcr/Smcr/CallbackResponse","path":"Smcr/CallbackResponse.html","kind":"alias","full_name":"Smcr::CallbackResponse","name":"CallbackResponse","abstract":false,"superclass":null,"ancestors":[],"locations":[{"filename":"src/smcr/state_machine.cr","line_number":17,"url":null}],"repository_name":"smcr","program":false,"enum":false,"alias":true,"aliased":"NamedTuple(succeeded: Bool, code: Int32, message: String)","aliased_html":"{succeeded: Bool, code: Int32, message: String}","const":false,"constants":[],"included_modules":[],"extended_modules":[],"subclasses":[],"including_types":[],"namespace":{"html_id":"smcr/Smcr","kind":"module","full_name":"Smcr","name":"Smcr"},"doc":null,"summary":null,"class_methods":[],"constructors":[],"instance_methods":[],"macros":[],"types":[]},{"html_id":"smcr/Smcr/CurrentErrors","path":"Smcr/CurrentErrors.html","kind":"alias","full_name":"Smcr::CurrentErrors","name":"CurrentErrors","abstract":false,"superclass":null,"ancestors":[],"locations":[{"filename":"src/smcr/state_machine.cr","line_number":28,"url":null}],"repository_name":"smcr","program":false,"enum":false,"alias":true,"aliased":"Hash(String, String)","aliased_html":"Hash(String, String)","const":false,"constants":[],"included_modules":[],"extended_modules":[],"subclasses":[],"including_types":[],"namespace":{"html_id":"smcr/Smcr","kind":"module","full_name":"Smcr","name":"Smcr"},"doc":null,"summary":null,"class_methods":[],"constructors":[],"instance_methods":[],"macros":[],"types":[]},{"html_id":"smcr/Smcr/HistorySize","path":"Smcr/HistorySize.html","kind":"alias","full_name":"Smcr::HistorySize","name":"HistorySize","abstract":false,"superclass":null,"ancestors":[],"locations":[{"filename":"src/smcr/state_machine.cr","line_number":7,"url":null}],"repository_name":"smcr","program":false,"enum":false,"alias":true,"aliased":"UInt8","aliased_html":"UInt8","const":false,"constants":[],"included_modules":[],"extended_modules":[],"subclasses":[],"including_types":[],"namespace":{"html_id":"smcr/Smcr","kind":"module","full_name":"Smcr","name":"Smcr"},"doc":"Bigger?","summary":"<p>Bigger?</p>","class_methods":[],"constructors":[],"instance_methods":[],"macros":[],"types":[]},{"html_id":"smcr/Smcr/PathsAllowed","path":"Smcr/PathsAllowed.html","kind":"alias","full_name":"Smcr::PathsAllowed","name":"PathsAllowed","abstract":false,"superclass":null,"ancestors":[],"locations":[{"filename":"src/smcr/state_machine.cr","line_number":11,"url":null}],"repository_name":"smcr","program":false,"enum":false,"alias":true,"aliased":"Hash(Int32, Array(Int32))","aliased_html":"Hash(Int32, Array(Int32))","const":false,"constants":[],"included_modules":[],"extended_modules":[],"subclasses":[],"including_types":[],"namespace":{"html_id":"smcr/Smcr","kind":"module","full_name":"Smcr","name":"Smcr"},"doc":null,"summary":null,"class_methods":[],"constructors":[],"instance_methods":[],"macros":[],"types":[]},{"html_id":"smcr/Smcr/StateChange","path":"Smcr/StateChange.html","kind":"alias","full_name":"Smcr::StateChange","name":"StateChange","abstract":false,"superclass":null,"ancestors":[],"locations":[{"filename":"src/smcr/state_machine.cr","line_number":21,"url":null}],"repository_name":"smcr","program":false,"enum":false,"alias":true,"aliased":"NamedTuple(state_value_became: Int32, tick_became: Int32, state_change_attempted: NamedTuple(forced: Bool, from: NamedTuple(state_value: Int32, tick: Int32), to: NamedTuple(state_value: Int32, tick: Int32)), callback_response: NamedTuple(succeeded: Bool, code: Int32, message: String))","aliased_html":"{state_value_became: Int32, tick_became: Int32, state_change_attempted: {forced: Bool, from: {state_value: Int32, tick: Int32}, to: {state_value: Int32, tick: Int32}}, callback_response: {succeeded: Bool, code: Int32, message: String}}","const":false,"constants":[],"included_modules":[],"extended_modules":[],"subclasses":[],"including_types":[],"namespace":{"html_id":"smcr/Smcr","kind":"module","full_name":"Smcr","name":"Smcr"},"doc":null,"summary":null,"class_methods":[],"constructors":[],"instance_methods":[],"macros":[],"types":[]},{"html_id":"smcr/Smcr/StateChangedAttempt","path":"Smcr/StateChangedAttempt.html","kind":"alias","full_name":"Smcr::StateChangedAttempt","name":"StateChangedAttempt","abstract":false,"superclass":null,"ancestors":[],"locations":[{"filename":"src/smcr/state_machine.cr","line_number":13,"url":null}],"repository_name":"smcr","program":false,"enum":false,"alias":true,"aliased":"NamedTuple(forced: Bool, from: NamedTuple(state_value: Int32, tick: Int32), to: NamedTuple(state_value: Int32, tick: Int32))","aliased_html":"{forced: Bool, from: {state_value: Int32, tick: Int32}, to: {state_value: Int32, tick: Int32}}","const":false,"constants":[],"included_modules":[],"extended_modules":[],"subclasses":[],"including_types":[],"namespace":{"html_id":"smcr/Smcr","kind":"module","full_name":"Smcr","name":"Smcr"},"doc":null,"summary":null,"class_methods":[],"constructors":[],"instance_methods":[],"macros":[],"types":[]},{"html_id":"smcr/Smcr/StateChangeHistory","path":"Smcr/StateChangeHistory.html","kind":"alias","full_name":"Smcr::StateChangeHistory","name":"StateChangeHistory","abstract":false,"superclass":null,"ancestors":[],"locations":[{"filename":"src/smcr/state_machine.cr","line_number":26,"url":null}],"repository_name":"smcr","program":false,"enum":false,"alias":true,"aliased":"Array(NamedTuple(state_value_became: Int32, tick_became: Int32, state_change_attempted: NamedTuple(forced: Bool, from: NamedTuple(state_value: Int32, tick: Int32), to: NamedTuple(state_value: Int32, tick: Int32)), callback_response: NamedTuple(succeeded: Bool, code: Int32, message: String)))","aliased_html":"Array({state_value_became: Int32, tick_became: Int32, state_change_attempted: {forced: Bool, from: {state_value: Int32, tick: Int32}, to: {state_value: Int32, tick: Int32}}, callback_response: {succeeded: Bool, code: Int32, message: String}})","const":false,"constants":[],"included_modules":[],"extended_modules":[],"subclasses":[],"including_types":[],"namespace":{"html_id":"smcr/Smcr","kind":"module","full_name":"Smcr","name":"Smcr"},"doc":null,"summary":null,"class_methods":[],"constructors":[],"instance_methods":[],"macros":[],"types":[]},{"html_id":"smcr/Smcr/StateMachine","path":"Smcr/StateMachine.html","kind":"class","full_name":"Smcr::StateMachine(State)","name":"StateMachine","abstract":false,"superclass":{"html_id":"smcr/Reference","kind":"class","full_name":"Reference","name":"Reference"},"ancestors":[{"html_id":"smcr/JSON/Serializable","kind":"module","full_name":"JSON::Serializable","name":"Serializable"},{"html_id":"smcr/Reference","kind":"class","full_name":"Reference","name":"Reference"},{"html_id":"smcr/Object","kind":"class","full_name":"Object","name":"Object"}],"locations":[{"filename":"src/smcr/state_machine.cr","line_number":30,"url":null}],"repository_name":"smcr","program":false,"enum":false,"alias":false,"aliased":null,"aliased_html":null,"const":false,"constants":[{"id":"ERROR_KEY_PATHS_ALLOWED","name":"ERROR_KEY_PATHS_ALLOWED","value":"\"paths_allowed\"","doc":"STATE_NOT_SET = :state_not_set","summary":"<p>STATE_NOT_SET = :state_not_set</p>"}],"included_modules":[{"html_id":"smcr/JSON/Serializable","kind":"module","full_name":"JSON::Serializable","name":"Serializable"}],"extended_modules":[],"subclasses":[],"including_types":[],"namespace":{"html_id":"smcr/Smcr","kind":"module","full_name":"Smcr","name":"Smcr"},"doc":null,"summary":null,"class_methods":[{"id":"state_class-class-method","html_id":"state_class-class-method","name":"state_class","doc":null,"summary":null,"abstract":false,"args":[],"args_string":"","args_html":"","location":{"filename":"src/smcr/state_machine.cr","line_number":45,"url":null},"def":{"name":"state_class","args":[],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"","visibility":"Public","body":"State.class"}},{"id":"state_internal_values-class-method","html_id":"state_internal_values-class-method","name":"state_internal_values","doc":null,"summary":null,"abstract":false,"args":[],"args_string":"","args_html":"","location":{"filename":"src/smcr/state_machine.cr","line_number":57,"url":null},"def":{"name":"state_internal_values","args":[],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"","visibility":"Public","body":"State.values.map(&.value)"}},{"id":"state_names-class-method","html_id":"state_names-class-method","name":"state_names","doc":null,"summary":null,"abstract":false,"args":[],"args_string":"","args_html":"","location":{"filename":"src/smcr/state_machine.cr","line_number":49,"url":null},"def":{"name":"state_names","args":[],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"","visibility":"Public","body":"State.names"}},{"id":"state_values-class-method","html_id":"state_values-class-method","name":"state_values","doc":null,"summary":null,"abstract":false,"args":[],"args_string":"","args_html":"","location":{"filename":"src/smcr/state_machine.cr","line_number":53,"url":null},"def":{"name":"state_values","args":[],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"","visibility":"Public","body":"State.values"}}],"constructors":[{"id":"new(pull:JSON::PullParser)-class-method","html_id":"new(pull:JSON::PullParser)-class-method","name":"new","doc":null,"summary":null,"abstract":false,"args":[{"name":"pull","doc":null,"default_value":"","external_name":"pull","restriction":"::JSON::PullParser"}],"args_string":"(pull : JSON::PullParser)","args_html":"(pull : JSON::PullParser)","location":{"filename":"src/smcr/state_machine.cr","line_number":31,"url":null},"def":{"name":"new","args":[{"name":"pull","doc":null,"default_value":"","external_name":"pull","restriction":"::JSON::PullParser"}],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"","visibility":"Public","body":"new_from_json_pull_parser(pull)"}},{"id":"new(state_default:State?=nil,history_size:HistorySize?=nil,tick:Tick?=nil,state:State?=nil,history:StateChangeHistory?=nil,paths_allowed:PathsAllowed?=nil)-class-method","html_id":"new(state_default:State?=nil,history_size:HistorySize?=nil,tick:Tick?=nil,state:State?=nil,history:StateChangeHistory?=nil,paths_allowed:PathsAllowed?=nil)-class-method","name":"new","doc":null,"summary":null,"abstract":false,"args":[{"name":"state_default","doc":null,"default_value":"nil","external_name":"state_default","restriction":"State | ::Nil"},{"name":"history_size","doc":null,"default_value":"nil","external_name":"history_size","restriction":"HistorySize | ::Nil"},{"name":"tick","doc":null,"default_value":"nil","external_name":"tick","restriction":"Tick | ::Nil"},{"name":"state","doc":null,"default_value":"nil","external_name":"state","restriction":"State | ::Nil"},{"name":"history","doc":null,"default_value":"nil","external_name":"history","restriction":"StateChangeHistory | ::Nil"},{"name":"paths_allowed","doc":null,"default_value":"nil","external_name":"paths_allowed","restriction":"PathsAllowed | ::Nil"}],"args_string":"(state_default : State? = <span class=\"n\">nil</span>, history_size : HistorySize? = <span class=\"n\">nil</span>, tick : Tick? = <span class=\"n\">nil</span>, state : State? = <span class=\"n\">nil</span>, history : StateChangeHistory? = <span class=\"n\">nil</span>, paths_allowed : PathsAllowed? = <span class=\"n\">nil</span>)","args_html":"(state_default : State? = <span class=\"n\">nil</span>, history_size : <a href=\"../Smcr/HistorySize.html\">HistorySize</a>? = <span class=\"n\">nil</span>, tick : <a href=\"../Smcr/Tick.html\">Tick</a>? = <span class=\"n\">nil</span>, state : State? = <span class=\"n\">nil</span>, history : <a href=\"../Smcr/StateChangeHistory.html\">StateChangeHistory</a>? = <span class=\"n\">nil</span>, paths_allowed : <a href=\"../Smcr/PathsAllowed.html\">PathsAllowed</a>? = <span class=\"n\">nil</span>)","location":{"filename":"src/smcr/state_machine.cr","line_number":61,"url":null},"def":{"name":"new","args":[{"name":"state_default","doc":null,"default_value":"nil","external_name":"state_default","restriction":"State | ::Nil"},{"name":"history_size","doc":null,"default_value":"nil","external_name":"history_size","restriction":"HistorySize | ::Nil"},{"name":"tick","doc":null,"default_value":"nil","external_name":"tick","restriction":"Tick | ::Nil"},{"name":"state","doc":null,"default_value":"nil","external_name":"state","restriction":"State | ::Nil"},{"name":"history","doc":null,"default_value":"nil","external_name":"history","restriction":"StateChangeHistory | ::Nil"},{"name":"paths_allowed","doc":null,"default_value":"nil","external_name":"paths_allowed","restriction":"PathsAllowed | ::Nil"}],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"","visibility":"Public","body":"_ = StateMachine(State).allocate\n_.initialize(state_default, history_size, tick, state, history, paths_allowed)\nif _.responds_to?(:finalize)\n  ::GC.add_finalizer(_)\nend\n_\n"}}],"instance_methods":[{"id":"add_path(state_from,state_to)-instance-method","html_id":"add_path(state_from,state_to)-instance-method","name":"add_path","doc":null,"summary":null,"abstract":false,"args":[{"name":"state_from","doc":null,"default_value":"","external_name":"state_from","restriction":""},{"name":"state_to","doc":null,"default_value":"","external_name":"state_to","restriction":""}],"args_string":"(state_from, state_to)","args_html":"(state_from, state_to)","location":{"filename":"src/smcr/state_machine.cr","line_number":106,"url":null},"def":{"name":"add_path","args":[{"name":"state_from","doc":null,"default_value":"","external_name":"state_from","restriction":""},{"name":"state_to","doc":null,"default_value":"","external_name":"state_to","restriction":""}],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"","visibility":"Public","body":"if @paths_allowed.keys.includes?(state_from.value)\nelse\n  @paths_allowed[state_from.value] = StatesAllowed.new\nend\nif @paths_allowed[state_from.value].includes?(state_to.value)\n  @paths_allowed[state_from.value].delete(state_to.value)\nend\n@paths_allowed[state_from.value] << state_to.value\n"}},{"id":"errors:CurrentErrors-instance-method","html_id":"errors:CurrentErrors-instance-method","name":"errors","doc":null,"summary":null,"abstract":false,"args":[],"args_string":" : CurrentErrors","args_html":" : <a href=\"../Smcr/CurrentErrors.html\">CurrentErrors</a>","location":{"filename":"src/smcr/state_machine.cr","line_number":43,"url":null},"def":{"name":"errors","args":[],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"CurrentErrors","visibility":"Public","body":"@errors"}},{"id":"history:StateChangeHistory-instance-method","html_id":"history:StateChangeHistory-instance-method","name":"history","doc":null,"summary":null,"abstract":false,"args":[],"args_string":" : StateChangeHistory","args_html":" : <a href=\"../Smcr/StateChangeHistory.html\">StateChangeHistory</a>","location":{"filename":"src/smcr/state_machine.cr","line_number":40,"url":null},"def":{"name":"history","args":[],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"StateChangeHistory","visibility":"Public","body":"@history"}},{"id":"history_size:HistorySize-instance-method","html_id":"history_size:HistorySize-instance-method","name":"history_size","doc":null,"summary":null,"abstract":false,"args":[],"args_string":" : HistorySize","args_html":" : <a href=\"../Smcr/HistorySize.html\">HistorySize</a>","location":{"filename":"src/smcr/state_machine.cr","line_number":37,"url":null},"def":{"name":"history_size","args":[],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"HistorySize","visibility":"Public","body":"@history_size"}},{"id":"initial_default_path-instance-method","html_id":"initial_default_path-instance-method","name":"initial_default_path","doc":null,"summary":null,"abstract":false,"args":[],"args_string":"","args_html":"","location":{"filename":"src/smcr/state_machine.cr","line_number":99,"url":null},"def":{"name":"initial_default_path","args":[],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"","visibility":"Public","body":"value_first = State.values.first.value\nvalues_all = State.values.map(&.value)\nvalues_other = values_all - [value_first]\n{value_first => values_other}\n"}},{"id":"paths_allowed:PathsAllowed-instance-method","html_id":"paths_allowed:PathsAllowed-instance-method","name":"paths_allowed","doc":"TODO!","summary":"<p><span class=\"flag orange\">TODO</span> !</p>","abstract":false,"args":[],"args_string":" : PathsAllowed","args_html":" : <a href=\"../Smcr/PathsAllowed.html\">PathsAllowed</a>","location":{"filename":"src/smcr/state_machine.cr","line_number":41,"url":null},"def":{"name":"paths_allowed","args":[],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"PathsAllowed","visibility":"Public","body":"@paths_allowed"}},{"id":"paths_allowed?(state_from,state_to)-instance-method","html_id":"paths_allowed?(state_from,state_to)-instance-method","name":"paths_allowed?","doc":null,"summary":null,"abstract":false,"args":[{"name":"state_from","doc":null,"default_value":"","external_name":"state_from","restriction":""},{"name":"state_to","doc":null,"default_value":"","external_name":"state_to","restriction":""}],"args_string":"(state_from, state_to)","args_html":"(state_from, state_to)","location":{"filename":"src/smcr/state_machine.cr","line_number":95,"url":null},"def":{"name":"paths_allowed?","args":[{"name":"state_from","doc":null,"default_value":"","external_name":"state_from","restriction":""},{"name":"state_to","doc":null,"default_value":"","external_name":"state_to","restriction":""}],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"","visibility":"Public","body":"(@paths_allowed.keys.includes?(state_from)) && (@paths_allowed[state_from].includes?(state_to))"}},{"id":"state:State-instance-method","html_id":"state:State-instance-method","name":"state","doc":null,"summary":null,"abstract":false,"args":[],"args_string":" : State","args_html":" : State","location":{"filename":"src/smcr/state_machine.cr","line_number":39,"url":null},"def":{"name":"state","args":[],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"State","visibility":"Public","body":"@state"}},{"id":"state_default:State-instance-method","html_id":"state_default:State-instance-method","name":"state_default","doc":null,"summary":null,"abstract":false,"args":[],"args_string":" : State","args_html":" : State","location":{"filename":"src/smcr/state_machine.cr","line_number":36,"url":null},"def":{"name":"state_default","args":[],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"State","visibility":"Public","body":"@state_default"}},{"id":"tick:Tick-instance-method","html_id":"tick:Tick-instance-method","name":"tick","doc":null,"summary":null,"abstract":false,"args":[],"args_string":" : Tick","args_html":" : <a href=\"../Smcr/Tick.html\">Tick</a>","location":{"filename":"src/smcr/state_machine.cr","line_number":38,"url":null},"def":{"name":"tick","args":[],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"Tick","visibility":"Public","body":"@tick"}},{"id":"valid?-instance-method","html_id":"valid?-instance-method","name":"valid?","doc":null,"summary":null,"abstract":false,"args":[],"args_string":"","args_html":"","location":{"filename":"src/smcr/state_machine.cr","line_number":89,"url":null},"def":{"name":"valid?","args":[],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"","visibility":"Public","body":"@errors.empty?"}},{"id":"validate-instance-method","html_id":"validate-instance-method","name":"validate","doc":null,"summary":null,"abstract":false,"args":[],"args_string":"","args_html":"","location":{"filename":"src/smcr/state_machine.cr","line_number":81,"url":null},"def":{"name":"validate","args":[],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"","visibility":"Public","body":"errors = CurrentErrors.new\nif @paths_allowed.keys.empty?\n  errors[ERROR_KEY_PATHS_ALLOWED] = \"must be an mapping of state to array of states\"\nend\nerrors\n"}}],"macros":[],"types":[]},{"html_id":"smcr/Smcr/StatesAllowed","path":"Smcr/StatesAllowed.html","kind":"alias","full_name":"Smcr::StatesAllowed","name":"StatesAllowed","abstract":false,"superclass":null,"ancestors":[],"locations":[{"filename":"src/smcr/state_machine.cr","line_number":10,"url":null}],"repository_name":"smcr","program":false,"enum":false,"alias":true,"aliased":"Array(Int32)","aliased_html":"Array(Int32)","const":false,"constants":[],"included_modules":[],"extended_modules":[],"subclasses":[],"including_types":[],"namespace":{"html_id":"smcr/Smcr","kind":"module","full_name":"Smcr","name":"Smcr"},"doc":null,"summary":null,"class_methods":[],"constructors":[],"instance_methods":[],"macros":[],"types":[]},{"html_id":"smcr/Smcr/StateValue","path":"Smcr/StateValue.html","kind":"alias","full_name":"Smcr::StateValue","name":"StateValue","abstract":false,"superclass":null,"ancestors":[],"locations":[{"filename":"src/smcr/state_machine.cr","line_number":2,"url":null}],"repository_name":"smcr","program":false,"enum":false,"alias":true,"aliased":"Int32","aliased_html":"Int32","const":false,"constants":[],"included_modules":[],"extended_modules":[],"subclasses":[],"including_types":[],"namespace":{"html_id":"smcr/Smcr","kind":"module","full_name":"Smcr","name":"Smcr"},"doc":null,"summary":null,"class_methods":[],"constructors":[],"instance_methods":[],"macros":[],"types":[]},{"html_id":"smcr/Smcr/Tick","path":"Smcr/Tick.html","kind":"alias","full_name":"Smcr::Tick","name":"Tick","abstract":false,"superclass":null,"ancestors":[],"locations":[{"filename":"src/smcr/state_machine.cr","line_number":6,"url":null}],"repository_name":"smcr","program":false,"enum":false,"alias":true,"aliased":"Int32","aliased_html":"Int32","const":false,"constants":[],"included_modules":[],"extended_modules":[],"subclasses":[],"including_types":[],"namespace":{"html_id":"smcr/Smcr","kind":"module","full_name":"Smcr","name":"Smcr"},"doc":"alias CurrentErrors = Hash(Symbol, String)\nalias State = T","summary":"<p>alias CurrentErrors = Hash(Symbol, String) alias State = T</p>","class_methods":[],"constructors":[],"instance_methods":[],"macros":[],"types":[]}]}]}})