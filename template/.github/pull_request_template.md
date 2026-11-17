Closes #<số issue>

## Thay đổi

<!-- Một đoạn ngắn: thay đổi gì, vì sao. -->

## Acceptance Criteria → thay đổi code → test

| AC | Thay đổi code | Test |
|---|---|---|
| AC1 | `<file>` | `<unit test>` |

## Checklist

- [ ] Branch theo quy ước (`feat|fix|chore/<số>-<slug>`), commit theo Conventional Commits
- [ ] Code theo coding standard của app bị ảnh hưởng (`apps/<app>/CODING_STANDARD.md`)
- [ ] Code theo thứ tự: contract dùng chung → API → web/admin → mobile
- [ ] Có unit test cho logic mới; có `data-testid` cho automation
- [ ] Lint, kiểm tra kiểu, unit test, build đều qua
- [ ] Đổi UI: khớp frame Figma
- [ ] Không có secret trong code/log
