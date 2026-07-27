//! Qwen3-0.6B Instruct Prompt Formatting Engine (ChatML Standard)

pub struct QwenPromptFormatter;

impl QwenPromptFormatter {
    pub fn format(system_prompt: &str, history: &[(String, String)], user_message: &str) -> String {
        let mut prompt = String::new();
        prompt.push_str(&format!(
            "<|im_start|>system\n{}\n<|im_end|>\n",
            system_prompt
        ));

        for (sender, msg) in history {
            let role = if sender == "user" {
                "user"
            } else {
                "assistant"
            };
            prompt.push_str(&format!("<|im_start|>{}\n{}\n<|im_end|>\n", role, msg));
        }

        prompt.push_str(&format!(
            "<|im_start|>user\n{}\n<|im_end|>\n<|im_start|>assistant\n",
            user_message
        ));
        prompt
    }
}
