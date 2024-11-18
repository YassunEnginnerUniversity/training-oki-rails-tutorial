"use server"

import { getCookie } from "@/actions/cookies/getCookies";

export const deleteLike = async (postId: string) => {
  const endpoint = process.env.NEXT_PUBLIC_API_ENDPOINT + "/api/posts/" + postId + "/unlike";
  const cookies = await getCookie();
  const response = await fetch(endpoint, {
    method: "POST",
    headers: {
      'Content-Type': 'application/json',
      Cookie: cookies,
    },
    credentials: 'include'
  })
  
  console.log(response);
  

  if(!response.ok) {
    return null
  }

  const like = response.json();
  return like
}