# Competition App - Design System Documentation

## Overview
This design system provides a comprehensive, modern UI framework for the Competition Management application built with Rails 8 and Tailwind CSS. All components follow a consistent visual language with dark gradients, modern typography, and accessible interactions.

---

## Design Principles

### 1. Visual Hierarchy
- **Clear information structure** through size, weight, color, and spacing
- **Typography scale** creates visual rhythm
- **Consistent spacing system** throughout (Tailwind's default scale)

### 2. Color Strategy
- **Primary**: Indigo (indigo-500, indigo-600)
- **Accent**: Purple, Pink for gradients
- **Background**: Dark gradient (from-slate-950 via-indigo-950 to-slate-900)
- **Content Cards**: White/95 opacity with shadow-2xl
- **Semantic Colors**:
  - Success: Emerald (emerald-50, emerald-700)
  - Warning: Amber (amber-50, amber-700)
  - Danger: Rose (rose-50, rose-600)
  - Info: Indigo (indigo-50, indigo-700)

### 3. Typography
- **Font**: System font stack via Tailwind
- **Headings**: Semibold (font-semibold), tracking-wide for uppercase
- **Body**: Regular weight, optimized line-height
- **Uppercase text**: tracking-[0.3em] or tracking-[0.4em]

### 4. Border Radius
- **Cards**: rounded-3xl
- **Inner elements**: rounded-2xl
- **Buttons**: rounded-full
- **Small elements**: rounded-xl

### 5. Shadows
- **Cards**: shadow-xl, shadow-2xl
- **Buttons**: shadow-lg with color-specific opacity (e.g., shadow-indigo-500/30)
- **Enhanced states**: hover:shadow-xl

---

## Component Library

All reusable components are located in `/app/views/shared/`.

### 1. Button (_button.html.erb)

**Usage:**
```erb
<%= render "shared/button",
    text: "Click me",
    variant: "primary",
    href: some_path,
    icon: "plus" %>
```

**Variants:**
- `primary`: Indigo background, white text, shadow
- `secondary`: White background, bordered, slate text
- `danger`: Rose border and background
- `outline`: Transparent with white border
- `dark`: Dark slate background

**Sizes:**
- `sm`: Smaller padding and text
- `md`: Default size (default)
- `lg`: Larger padding and text

**Props:**
- `text` (required): Button text
- `variant`: Button style variant
- `href`: Link destination (creates link instead of button)
- `method`: HTTP method for button_to
- `confirm`: Confirmation message
- `icon`: Heroicon name
- `icon_position`: "left" or "right"
- `size`: Button size
- `full_width`: true/false
- `extra_classes`: Additional CSS classes

### 2. Card (_card.html.erb)

**Usage:**
```erb
<%= render "shared/card",
    title: "Card Title",
    subtitle: "Subtitle",
    badge_count: 5 do %>
  Card content here
<% end %>
```

**Variants:**
- `default`: White background, subtle border
- `gradient`: Gradient background (indigo → purple → pink)
- `bordered`: White background, stronger border
- `inner`: Nested card style with hover effects

**Props:**
- `title`: Card heading
- `subtitle`: Small text above title
- `variant`: Card style variant
- `badge_text`: Badge text next to title
- `badge_count`: Number badge
- `extra_classes`: Additional CSS classes

### 3. Form Field (_form_field.html.erb)

**Usage:**
```erb
<%= render "shared/form_field",
    form: form,
    field: :email,
    label: "Email Address",
    type: "email",
    required: true,
    help_text: "We'll never share your email" %>
```

**Field Types:**
- `text`: Text input (default)
- `email`: Email input
- `password`: Password input
- `number`: Number input
- `textarea`: Multi-line text
- `select`: Dropdown select

**Props:**
- `form` (required): Form builder object
- `field` (required): Field name symbol
- `label`: Label text
- `type`: Field type
- `placeholder`: Placeholder text
- `required`: true/false
- `autofocus`: true/false
- `help_text`: Help text below field
- `options`: Options for select fields
- `include_blank`: Blank option for selects
- `rows`: Rows for textarea (default: 4)

**Features:**
- Automatic error state styling
- ARIA attributes for accessibility
- Focus states with ring-2
- Error messages displayed inline

### 4. Badge (_badge.html.erb)

**Usage:**
```erb
<%= render "shared/badge",
    text: "Active",
    variant: "success",
    size: "md" %>
```

**Variants:**
- `default`: Slate background
- `success`: Emerald background
- `warning`: Amber background
- `danger`: Rose background
- `info`: Indigo background
- `primary`: Indigo background with shadow

**Sizes:**
- `sm`: Small padding
- `md`: Medium padding (default)
- `lg`: Large padding

### 5. Empty State (_empty_state.html.erb)

**Usage:**
```erb
<%= render "shared/empty_state",
    icon: "users",
    title: "No participants yet",
    description: "Add your first participant",
    action_text: "Add Participant",
    action_url: new_participant_path %>
```

**Props:**
- `icon`: Heroicon name
- `title` (required): Main heading
- `description`: Description text
- `action_text`: Button text
- `action_url`: Button destination

### 6. Page Header (_page_header.html.erb)

**Usage:**
```erb
<%= render "shared/page_header",
    title: "My Page",
    breadcrumb: "Dashboard",
    subtitle: "Page description",
    action_text: "New Item",
    action_url: new_item_path,
    variant: "default" %>
```

**Variants:**
- `default`: Simple header with optional action button
- `gradient`: Full-width gradient background header

**Props:**
- `title` (required): Main heading
- `subtitle`: Subtitle text
- `breadcrumb`: Small text above title
- `action_text`: Primary action button
- `action_url`: Action button URL
- `variant`: Header style

---

## Heroicons Integration

Icons are integrated via inline SVG sprite in the application layout. Available icons:

- `plus`: Add/create actions
- `trash`: Delete actions
- `pencil`: Edit actions
- `eye`: View actions
- `users`: User/participant icons
- `trophy`: Competition icons
- `chart-bar`: Dashboard/analytics icons
- `arrow-right`: Navigation arrows
- `document`: Document/rules icons
- `star`: Featured/special items
- `folder`: Folder/organization icons
- `check`: Success/confirmation
- `x`: Close/error
- `cog`: Settings

**Usage:**
```erb
<svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor">
  <use href="#heroicon-plus" />
</svg>
```

---

## Layout Structure

### Application Layout
- **Background**: Dark gradient (from-slate-950 via-indigo-950 to-slate-900)
- **Navigation**: Glass morphism header with backdrop-blur
- **Main content**: White/95 card with rounded-3xl and shadow-2xl
- **Max width**: 6xl (1280px)
- **Padding**: px-6 py-10

### Navigation Header
- **Icons with text**: Hover transitions on all links
- **Logo**: Trophy icon + brand name
- **User menu**: Contextual based on auth state
- **Mobile responsive**: Flex-wrap for smaller screens

### Flash Messages
- **Success (notice)**: Emerald background
- **Error (alert)**: Rose background
- **Default**: Slate background
- **Style**: Rounded-xl border with padding

---

## Interaction Patterns

### Hover States
- **Cards**: hover:shadow-xl hover:border-indigo-200 hover:bg-white
- **Buttons**: hover:bg-indigo-500 hover:shadow-xl
- **Scale**: hover:scale-105 on grid items
- **Active**: active:scale-95 on buttons

### Transitions
- **Duration**: transition-all duration-200
- **Colors**: transition-colors
- **Specific**: Individual properties as needed

### Focus States
- **Inputs**: focus:border-indigo-500 focus:ring-2 focus:ring-indigo-200
- **Buttons**: Focus visible with outline
- **Keyboard navigation**: All interactive elements accessible

---

## Accessibility Features

### WCAG 2.1 AA Compliance
- **Color contrast**: Minimum 4.5:1 for text, 3:1 for UI components
- **Focus indicators**: Visible ring on all focusable elements
- **ARIA labels**: Proper labeling for form fields and buttons
- **Keyboard navigation**: Full keyboard support
- **Screen readers**: Semantic HTML and ARIA attributes
- **Error messages**: role="alert" and linked to fields via aria-describedby

### Form Accessibility
- Labels associated with inputs
- Help text linked via aria-describedby
- Error messages with semantic markup
- Required fields clearly indicated
- Focus states always visible

---

## Responsive Design

### Breakpoints
- **Mobile**: Default (< 640px)
- **Tablet**: md: (768px)
- **Desktop**: lg: (1024px)
- **Wide**: xl: (1280px)

### Grid Layouts
```tailwind
grid gap-4 md:grid-cols-2 lg:grid-cols-3
```

### Mobile-First Approach
- Start with mobile layout
- Progressive enhancement for larger screens
- Touch-friendly targets (min 44x44px)
- Readable typography on all devices

---

## File Structure

```
app/views/
├── shared/
│   ├── _button.html.erb           # Button component
│   ├── _card.html.erb              # Card container component
│   ├── _form_field.html.erb        # Form input component
│   ├── _badge.html.erb             # Status badge component
│   ├── _empty_state.html.erb       # Empty state component
│   └── _page_header.html.erb       # Page header component
├── layouts/
│   └── application.html.erb        # Main layout with Heroicons
├── competitions/                   # Competition views
├── participants/                   # Participant views
├── rankings/                       # Ranking views
└── users/                         # User views
```

---

## Best Practices

### Component Usage
1. **Always use shared components** for consistency
2. **Pass appropriate variants** for context
3. **Include help text** on complex form fields
4. **Use icons** to enhance visual hierarchy
5. **Test accessibility** with keyboard navigation

### Styling Guidelines
1. **Use Tailwind classes only** - no custom CSS
2. **Follow established patterns** from existing views
3. **Maintain responsive behavior** - test on mobile
4. **Keep color palette consistent** - stick to design tokens
5. **Add transitions** to all interactive elements

### Form Design
1. **Group related fields** logically
2. **Provide clear labels** and help text
3. **Show validation errors** inline
4. **Use appropriate input types** for data
5. **Include cancel actions** on all forms

### Empty States
1. **Always provide empty states** for lists
2. **Include helpful icons** and descriptions
3. **Offer clear call-to-action** when appropriate
4. **Make them visually distinct** but not alarming

---

## Quick Reference

### Common Color Combinations
```
Primary action:     bg-indigo-600 text-white
Secondary action:   border-slate-300 text-slate-700
Danger action:      bg-rose-50 text-rose-600 border-rose-200
Success state:      bg-emerald-50 text-emerald-700
Warning state:      bg-amber-50 text-amber-700
```

### Common Spacing
```
Card padding:       p-6
Section spacing:    space-y-8
Form fields:        space-y-5
Button groups:      gap-3
Grid gaps:          gap-4
```

### Common Shadows
```
Cards:              shadow-xl
Buttons:            shadow-lg shadow-indigo-500/30
Hover enhance:      hover:shadow-xl
Icon backgrounds:   shadow-lg
```

---

## Maintenance

When adding new features:
1. Check if existing components can be used
2. Follow established design patterns
3. Maintain accessibility standards
4. Test responsive behavior
5. Update this documentation if creating new patterns

---

**Design System Version**: 1.0
**Last Updated**: November 2025
**Maintained by**: UI Designer Agent
