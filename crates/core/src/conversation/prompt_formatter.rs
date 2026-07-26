//! Gemma 3 1B Prompt Formatting Engine

pub struct GemmaPromptFormatter;

impl GemmaPromptFormatter {
    pub fn format(system_prompt: &str, history: &[(String, String)], user_message: &str) -> String {
        let mut prompt = String::new();
        prompt.push_str(&format!(
            "<start_of_turn>system\n{}\n<end_of_turn>\n",
            system_prompt
        ));

        for (sender, msg) in history {
            let role = if sender == "user" { "user" } else { "model" };
            prompt.push_str(&format!(
                "<start_of_turn>{}\n{}\n<end_of_turn>\n",
                role, msg
            ));
        }

        prompt.push_str(&format!(
            "<start_of_turn>user\n{}\n<end_of_turn>\n<start_of_turn>model\n",
            user_message
        ));
        prompt
    }
}
