import { defineConfig } from 'vitepress'

const REPO = 'https://github.com/phoenixit99/wata-ai-process'

function sidebarVi() {
  return [
    {
      text: 'Quy trình',
      items: [
        { text: 'Quy trình v1.3', link: '/process' },
        { text: 'RACI theo trạng thái', link: '/raci' },
        { text: 'Phân loại rủi ro', link: '/risk-tiers' },
        { text: 'Viết Acceptance Criteria', link: '/writing-acceptance-criteria' },
        { text: 'Thuật ngữ', link: '/glossary' }
      ]
    },
    {
      text: 'Hướng dẫn theo vai trò',
      items: [
        { text: 'PO', link: '/roles/po' },
        { text: 'BA', link: '/roles/ba' },
        { text: 'PM', link: '/roles/pm' },
        { text: 'Designer', link: '/roles/designer' },
        { text: 'Developer', link: '/roles/dev' },
        { text: 'Tech Lead', link: '/roles/tech-lead' },
        { text: 'QA', link: '/roles/qa' }
      ]
    },
    {
      text: 'Skill và AI Agent',
      items: [
        { text: 'Danh mục skill', link: '/skills' },
        { text: 'Contract cho AI', link: '/contract' }
      ]
    },
    {
      text: 'Triển khai',
      items: [
        { text: 'Cài đặt cho project', link: '/setup-guide' },
        { text: 'Coding standard: Next.js', link: '/coding-standards/nextjs' },
        { text: 'Coding standard: NestJS', link: '/coding-standards/nestjs' },
        { text: 'Coding standard: Flutter', link: '/coding-standards/flutter' }
      ]
    }
  ]
}

function sidebarEn() {
  return [
    {
      text: 'Process',
      items: [
        { text: 'Process v1.3', link: '/en/process' },
        { text: 'RACI by status', link: '/en/raci' },
        { text: 'Risk tiers', link: '/en/risk-tiers' },
        { text: 'Writing acceptance criteria', link: '/en/writing-acceptance-criteria' },
        { text: 'Glossary', link: '/en/glossary' }
      ]
    },
    {
      text: 'Role guides',
      items: [
        { text: 'PO', link: '/en/roles/po' },
        { text: 'BA', link: '/en/roles/ba' },
        { text: 'PM', link: '/en/roles/pm' },
        { text: 'Designer', link: '/en/roles/designer' },
        { text: 'Developer', link: '/en/roles/dev' },
        { text: 'Tech Lead', link: '/en/roles/tech-lead' },
        { text: 'QA', link: '/en/roles/qa' }
      ]
    },
    {
      text: 'Skills and the AI agent',
      items: [
        { text: 'Skill catalog', link: '/en/skills' },
        { text: 'Agent contract', link: '/en/contract' }
      ]
    },
    {
      text: 'Adoption',
      items: [
        { text: 'Project setup', link: '/en/setup-guide' },
        { text: 'Coding standard: Next.js', link: '/en/coding-standards/nextjs' },
        { text: 'Coding standard: NestJS', link: '/en/coding-standards/nestjs' },
        { text: 'Coding standard: Flutter', link: '/en/coding-standards/flutter' }
      ]
    }
  ]
}

export default defineConfig({
  title: 'WATA AI Process',
  description: 'Quy trình phát triển dự án sử dụng AI Agent — WATA Software',
  cleanUrls: true,
  lastUpdated: true,
  head: [
    ['link', { rel: 'icon', href: '/favicon.svg', type: 'image/svg+xml' }],
    ['meta', { name: 'theme-color', content: '#9e1b20' }]
  ],
  // README, template và skill nằm ngoài docs/; link tới chúng đi qua GitHub.
  ignoreDeadLinks: [/^\.\.\//],
  markdown: {
    // Tài liệu dùng nhiều placeholder dạng <số issue>; không coi là thẻ HTML.
    html: false
  },
  themeConfig: {
    logo: '/logo.svg',
    socialLinks: [{ icon: 'github', link: REPO }],
    search: { provider: 'local' }
  },
  locales: {
    root: {
      label: 'Tiếng Việt',
      lang: 'vi',
      themeConfig: {
        nav: [
          { text: 'Quy trình', link: '/process' },
          { text: 'Vai trò', link: '/roles/po' },
          { text: 'Skill', link: '/skills' },
          { text: 'Cài đặt', link: '/setup-guide' }
        ],
        sidebar: sidebarVi(),
        outline: { label: 'Trong trang này', level: [2, 3] },
        docFooter: { prev: 'Trang trước', next: 'Trang sau' },
        lastUpdated: { text: 'Cập nhật' },
        editLink: { pattern: `${REPO}/edit/main/docs/:path`, text: 'Sửa trang này trên GitHub' },
        footer: { message: 'WATA Software · Tài liệu nội bộ', copyright: 'Phiên bản 1.3.0' },
        darkModeSwitchLabel: 'Giao diện',
        sidebarMenuLabel: 'Mục lục',
        returnToTopLabel: 'Lên đầu trang',
        langMenuLabel: 'Ngôn ngữ'
      }
    },
    en: {
      label: 'English',
      lang: 'en',
      link: '/en/',
      description: 'AI Agent software development process — WATA Software',
      themeConfig: {
        nav: [
          { text: 'Process', link: '/en/process' },
          { text: 'Roles', link: '/en/roles/po' },
          { text: 'Skills', link: '/en/skills' },
          { text: 'Setup', link: '/en/setup-guide' }
        ],
        sidebar: sidebarEn(),
        outline: { level: [2, 3] },
        editLink: { pattern: `${REPO}/edit/main/docs/:path`, text: 'Edit this page on GitHub' },
        footer: { message: 'WATA Software · Internal document', copyright: 'Version 1.3.0' }
      }
    }
  }
})
