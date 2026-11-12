-- NestJS debugging profiles.
--
-- `lang.typescript` already registers the `js-debug-adapter` and the generic
-- JavaScript/TypeScript configurations. This spec only prepends NestJS-specific
-- profiles, so the LazyVim defaults and keymaps remain untouched.
return {
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")

      local skip_files = {
        "<node_internals>/**",
        "node_modules/**",
      }

      local resolve_source_map_locations = {
        "${workspaceFolder}/**",
        "!**/node_modules/**",
      }

      local configs = {
        {
          type = "pwa-node",
          request = "launch",
          name = "NestJS: Launch",
          -- Nest CLI uses tsc, which preserves `emitDecoratorMetadata`.
          -- Avoid `tsx` here: esbuild does not support that option and Nest's
          -- dependency injection would break at runtime.
          runtimeExecutable = "npm",
          runtimeArgs = { "run", "start:debug" },
          cwd = "${workspaceFolder}",
          console = "integratedTerminal",
          autoAttachChildProcesses = true,
          restart = true,
          sourceMaps = true,
          outFiles = { "${workspaceFolder}/dist/**/*.js" },
          skipFiles = skip_files,
          resolveSourceMapLocations = resolve_source_map_locations,
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "NestJS: Attach 9229",
          port = 9229,
          cwd = "${workspaceFolder}",
          restart = true,
          sourceMaps = true,
          outFiles = { "${workspaceFolder}/dist/**/*.js" },
          skipFiles = skip_files,
          resolveSourceMapLocations = resolve_source_map_locations,
        },
      }

      local filetypes = { "typescript" }
      for _, ft in ipairs(filetypes) do
        dap.configurations[ft] = dap.configurations[ft] or {}

        local existing = dap.configurations[ft]
        local names = {}
        for _, config in ipairs(existing) do
          names[config.name] = true
        end

        local nestjs = {}
        for _, config in ipairs(configs) do
          if not names[config.name] then
            table.insert(nestjs, config)
          end
        end

        dap.configurations[ft] = vim.list_extend(nestjs, existing)

        -- LazyVim's generic "Launch file" falls back to `ts-node` when `tsx`
        -- is not on PATH. Use the project-local `tsx` so the fallback works.
        for _, config in ipairs(dap.configurations[ft]) do
          if config.name == "Launch file" and config.runtimeExecutable == "ts-node" then
            config.runtimeExecutable = "${workspaceFolder}/node_modules/.bin/tsx"
          end
        end
      end
    end,
  },
}
