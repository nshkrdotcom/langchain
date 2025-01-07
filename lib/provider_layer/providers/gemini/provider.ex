     {:ok, response} -> 
       text = get_in(response, ["candidates", Access.at(0), "content", "parts", Access.at(0), "text"])
       {:ok, text}
     {:ok, response} -> 
       text = get_in(response, ["candidates", Access.at(0), "content", "parts", Access.at(0), "text"])
       {:ok, text}
     {:ok, response} -> 
       text = get_in(response, ["candidates", Access.at(0), "content", "parts", Access.at(0), "text"])
       {:ok, text}
 def generate_content(prompt, opts \\ []) do
   case GenerativeModel.generate_content(prompt, opts) do
     {:ok, response} -> 
       text = get_in(response, ["candidates", Access.at(0), "content", "parts", Access.at(0), "text"])
       {:ok, text}
     error -> error
   end
 end
