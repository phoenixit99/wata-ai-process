import { defineConfig } from 'vitepress'

const REPO = 'https://github.com/phoenixit99/wata-ai-process'

function sidebarVi() {
  return [
    {
      text: 'Quy trình',
      items: [
        { text: 'Quy trình phát triển', link: '/process' },
        { text: 'Quy trình Scrum', link: '/scrum' },
        { text: 'Viết Acceptance Criteria', link: '/writing-acceptance-criteria' }
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
        { text: 'nextjs-coding-standard', link: '/coding-standards/nextjs-coding-standard' },
        { text: 'nestjs-coding-standard', link: '/coding-standards/nestjs-coding-standard' },
        { text: 'flutter-coding-standard', link: '/coding-standards/flutter-coding-standard' }
      ]
    }
  ]
}

function sidebarEn() {
  return [
    {
      text: 'Process',
      items: [
        { text: 'Development process', link: '/en/process' },
        { text: 'Scrum process', link: '/en/scrum' },
        { text: 'Writing acceptance criteria', link: '/en/writing-acceptance-criteria' }
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
        { text: 'nextjs-coding-standard', link: '/en/coding-standards/nextjs-coding-standard' },
        { text: 'nestjs-coding-standard', link: '/en/coding-standards/nestjs-coding-standard' },
        { text: 'flutter-coding-standard', link: '/en/coding-standards/flutter-coding-standard' }
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
    ['link', { rel: 'icon', href: '/wata-mark.png', type: 'image/png' }],
    ['meta', { name: 'theme-color', content: '#9e1b20' }]
  ],
  // README, template và skill nằm ngoài docs/; link tới chúng đi qua GitHub.
  ignoreDeadLinks: [/^\.\.\//],
  markdown: {
    // Tài liệu dùng nhiều placeholder dạng <số issue>; không coi là thẻ HTML.
    html: false
  },
  themeConfig: {
    logo: { src: '/wata-logo.png', alt: 'WATA Software' },
    siteTitle: 'AI Process',
    socialLinks: [{ icon: 'github', link: REPO }],
    search: { provider: 'local' }
  },
  locales: {
    root: {
      label: 'Tiếng Việt',
      lang: 'vi',
      themeConfig: {
        nav: [
          { text: 'Quy trình dev', link: '/process' },
          { text: 'Scrum', link: '/scrum' },
          { text: 'Skill', link: '/skills' },
          { text: 'Cài đặt', link: '/setup-guide' }
        ],
        sidebar: sidebarVi(),
        outline: { label: 'Trong trang này', level: [2, 3] },
        docFooter: { prev: 'Trang trước', next: 'Trang sau' },
        lastUpdated: { text: 'Cập nhật' },
        editLink: { pattern: `${REPO}/edit/main/docs/:path`, text: 'Sửa trang này trên GitHub' },
        footer: { message: 'WATA Software · Tài liệu nội bộ', copyright: 'Phiên bản 1.0' },
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
          { text: 'Dev process', link: '/en/process' },
          { text: 'Scrum', link: '/en/scrum' },
          { text: 'Skills', link: '/en/skills' },
          { text: 'Setup', link: '/en/setup-guide' }
        ],
        sidebar: sidebarEn(),
        outline: { level: [2, 3] },
        editLink: { pattern: `${REPO}/edit/main/docs/:path`, text: 'Edit this page on GitHub' },
        footer: { message: 'WATA Software · Internal document', copyright: 'Version 1.0' }
      }
    }
  }
})
