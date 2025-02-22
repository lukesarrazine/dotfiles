local M = {}

function M.setup_roslyn()
    local mason_path = vim.fn.stdpath("data") .. "/mason/packages/roslyn/libexec"
    local roslyn_dll = mason_path .. "/Microsoft.CodeAnalysis.LanguageServer.dll"
    local capabilities = require('blink.cmp').get_lsp_capabilities()

    require('roslyn').setup({
        exe = { 'dotnet', roslyn_dll },
        config = {
            capabilties = capabilities,
            filetypes = { "cs" },
            settings = {
                ['csharp|inlay_hints'] = {
                    csharp_enable_inlay_hints_for_implicit_object_creation = true,
                    csharp_enable_inlay_hints_for_implicit_variable_types = true,
                    csharp_enable_inlay_hints_for_lambda_parameter_types = true,
                    csharp_enable_inlay_hints_for_types = true,
                    dotnet_enable_inlay_hints_for_indexer_parameters = true,
                    dotnet_enable_inlay_hints_for_literal_parameters = true,
                    dotnet_enable_inlay_hints_for_object_creation_parameters = true,
                    dotnet_enable_inlay_hints_for_other_parameters = true,
                    dotnet_enable_inlay_hints_for_parameters = true,
                    dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
                    dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
                    dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
                },
                ['csharp|code_lens'] = {
                    dotnet_enable_references_code_lens = true,
                    dotnet_enable_tests_code_lens = true,
                },
                ['csharp|completion'] = {
                    dotnet_provide_regex_completions = true,
                    dotnet_show_completion_items_from_unimported_namespaces = true,
                    dotnet_show_name_completion_suggestions = true,
                },
                ['csharp|highlighting'] = {
                    dotnet_highlight_related_json_components = true,
                    dotnet_highlight_related_regex_components = true,
                },
            },
        },
    })
end

function M.setup_razor()
    require('roslyn').setup {
        args = {
            '--logLevel=Information',
            '--extensionLogDirectory=' .. vim.fs.dirname(vim.lsp.get_log_path()),
            '--razorSourceGenerator='
            .. vim.fs.joinpath(vim.fn.stdpath 'data' --[[@as string]], 'mason', 'packages', 'roslyn', 'libexec', 'Microsoft.CodeAnalysis.Razor.Compiler.dll'),
            '--razorDesignTimePath=' .. vim.fs.joinpath(
                vim.fn.stdpath 'data' --[[@as string]],
                'mason',
                'packages',
                'rzls',
                'libexec',
                'Targets',
                'Microsoft.NET.Sdk.Razor.DesignTime.targets'
            ),
        },
        ---@diagnostic disable-next-line: missing-fields
        config = {
            filetypes = { "cs", "razor" },
            handlers = require 'rzls.roslyn_handlers',
            settings = {
                ['csharp|inlay_hints'] = {
                    csharp_enable_inlay_hints_for_implicit_object_creation = true,
                    csharp_enable_inlay_hints_for_implicit_variable_types = true,

                    csharp_enable_inlay_hints_for_lambda_parameter_types = true,
                    csharp_enable_inlay_hints_for_types = true,
                    dotnet_enable_inlay_hints_for_indexer_parameters = true,
                    dotnet_enable_inlay_hints_for_literal_parameters = true,
                    dotnet_enable_inlay_hints_for_object_creation_parameters = true,
                    dotnet_enable_inlay_hints_for_other_parameters = true,
                    dotnet_enable_inlay_hints_for_parameters = true,
                    dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
                    dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
                    dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
                },
                ['csharp|code_lens'] = {
                    dotnet_enable_references_code_lens = true,
                },
            },
        },
    }
end

return {
    "seblyng/roslyn.nvim",
    dependencies = {
        {
            -- By loading as a dependencies, we ensure that we are available to set
            -- the handlers for roslyn
            'tris203/rzls.nvim',
            config = function()
                ---@diagnostic disable-next-line: missing-fields
                require('rzls').setup {}
            end,
        },
    },
    opts = {},
    config = function()
        local find_razor_utils = require("util.find_razor_files")
        local root_dir = vim.fn.getcwd()
        local has_razor_files = find_razor_utils.has_razor_files_cached(root_dir)

        if has_razor_files then
            M.setup_razor()
        else
            M.setup_roslyn()
        end
    end
}

