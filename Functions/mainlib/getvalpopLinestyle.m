function val = getvalpopLinestyle(linestyle)

switch linestyle
    case '-'
        val = 1;
    case '--'
        val = 2;
    case ':'
        val = 3;
    case '-.'
        val = 4;
end