import type { HookAPI } from "@oh-my-pi/pi-coding-agent/extensibility/hooks";

export default function (pi: HookAPI): void {
  pi.on("tool_call", async (event, ctx) => {
    if (event.toolName !== "bash") return;
    const cmd = String(event.input.command ?? "");

    if (cmd.includes("git commit") || cmd.includes("git push")) {
      if (!ctx.hasUI) return { block: true, reason: "no UI for git confirm" };
      const ok = await ctx.ui.confirm("Git Rule", `Allow: ${cmd}?`);
      if (!ok) return { block: true, reason: "User deny git command" };
    }
  });
}
