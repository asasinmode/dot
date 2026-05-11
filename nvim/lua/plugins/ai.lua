local system_prompt = "You are grug brain developer. Speak lowercase, broken grammar, cave-pidgin. Refer to self as 'grug'.\n"
	.. "Rules:\n"
	.. "- No bold, no italics. Use plain text only.\n"
	.. "- In code blocks, use tabs instead of spaces.\n"
	.. "- Short sentences (<15 words). Max 3 sentences per paragraph. Avoid paragraphs of talking to yourself in grug reasoning, head straight for the answer to the user's question.\n"
	.. "- Use single-line beats like 'is fine.' or 'complexity demon smile.'\n"
	.. "- Use H3 (###) only if >250 words. Use bullets only for 3+ items.\n"
	.. "- No fancy words (implement, optimize, abstraction). Use: make, fast, layer.\n"
	.. "- The naming in actual code should still be professional, no grug words there (comments are fine).\n"
	.. "Philosophy:\n"
	.. "- Complexity is demon spirit. Say 'no' to features/abstractions.\n"
	.. "- 80/20 way: 80% result with 20% code.\n"
	.. "- Respect fence: don't delete code until know why it there.\n"
	.. "- Test integration, not mocks. Log everything. Use debugger.\n"
	.. "- Type systems good for 'hit dot, see what do'. Avoid generics.\n"
	.. "- Microservices, SPA, GraphQL = lair for demon. Stay boring. Use monolith and HTML.\n"
	.. "- DRY bad if make code hard to find. Locality of behavior good.\n"
	.. "Goal: Give blunt, practical, hard-won software wisdom. Be funny but wise."

return {
	-- was used for getting the auth token
	-- { "github/copilot.vim" },
	{
		"Konkord360/gp.nvim",
		config = function()
			require("gp").setup({
				providers = {
					openai = {},
					googleai = {
						secret = os.getenv("GEMINI_API_KEY"),
					},
					copilot = {
						disable = false,
						secret = {
							"powershell",
							"-Command",
							"Get-Content $env:LOCALAPPDATA\\github-copilot\\apps.json | jq -r '.[] | select(.oauth_token) | .oauth_token' | Select-Object -First 1",
						},
					},
					groq = {
						disable = false,
						endpoint = "https://api.groq.com/openai/v1/chat/completions",
						secret = os.getenv("GROQ_API_KEY"),
					},
				},
				agents = {
					{
						provider = "googleai",
						name = "ChatGemini",
						chat = true,
						model = { model = "gemini-3-flash-preview" },
						system_prompt = system_prompt,
					},
					{
						name = "ChatCopilot",
						provider = "copilot",
						chat = true,
						model = { model = "gpt-4o", temperature = 1.1, top_p = 1 },
						system_prompt = system_prompt,
					},
					{
						provider = "groq",
						name = "GroqCompound",
						chat = true,
						model = { model = "groq/compound" },
						system_prompt = system_prompt,
					},
					{
						provider = "groq",
						name = "GroqCompoundMini",
						chat = true,
						model = { model = "groq/compound-mini" },
						system_prompt = system_prompt,
					},
					{
						provider = "groq",
						name = "OllamaLlama3.3",
						chat = true,
						model = {
							model = "llama-3.3-70b-versatile",
							temperature = 0.8,
							top_p = 1,
							min_p = 0.05,
						},
						system_prompt = system_prompt,
					},
				},
				default_chat_agent = "ChatGemini",
				chat_template = require("gp.defaults").short_chat_template,
			})
		end,
		whisper = {
			disable = true,
		},
		image = {
			disable = true,
		},
		keys = {
			{ "<leader>ain", "<cmd>GpChatNew<cr>", desc = "new gp chat" },
			{ "<leader>ail", "<cmd>GpChatLast<cr>", desc = "last gp chat" },
			{ "<leader>aif", "<cmd>GpChatFinder<cr>", desc = "find gp chat" },
		},
	},
}
